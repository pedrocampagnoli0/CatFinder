import os
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import torch
import torch.nn as nn
from torch.optim import Adam
from torch.utils.data import Dataset, DataLoader
import torchvision.transforms.v2 as transforms
from torchvision.models import vgg16
from torchvision.models import VGG16_Weights
import httpx
from io import BytesIO
from collections import OrderedDict

import logging
# import glob
from PIL import Image


app = FastAPI()

logging.basicConfig(
    format='%(asctime)s - %(levelname)s - %(message)s',
    level=logging.INFO
)

# check if has gpu avalable
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

N_CLASSES = 1
IMG_WIDTH, IMG_HEIGHT = (224, 224)
DATA_LABELS = ['cat', 'ncat']
BUCKETS = ['cloud-object-storage-cos-standard-9b3']


def return_base_storage_url(bucket: str, label: str, file_name: str) -> str:
    return f'https://{bucket}.s3.us-south.cloud-object-storage.appdomain.cloud/{label}/{file_name}'


class MyDataset(Dataset):
	def __init__(self, pre_trans, bucket, n_img, is_train):
		self.imgs = []
		self.labels = []
        
		for l_idx, label in enumerate(DATA_LABELS):
			for img_name in [f'cat_{n}.jpg' for n in range(n_img[l_idx])]:
				full_label = 'train/' + label if is_train else 'valid/' + label
				response = httpx.get(return_base_storage_url(bucket, full_label, img_name))
				img = Image.open(BytesIO(response.content))
				self.imgs.append(pre_trans(img).to(device))
				self.labels.append(torch.tensor(l_idx).to(device).float())

	def __getitem__(self, idx):
		img = self.imgs[idx]
		label = self.labels[idx]
		return img, label

	def __len__(self):
		return len(self.imgs)


def get_batch_accuracy(output, y, N):
    zero_tensor = torch.tensor([0]).to(device)
    pred = torch.gt(output, zero_tensor)
    correct = pred.eq(y.view_as(pred)).sum().item()
    return correct / N


def train(
	model,
	train_loader,
	train_N,
    random_trans,
    optimizer,
    loss_function,
	check_grad=False
):
    loss = 0
    accuracy = 0

    model.train()
    for x, y in train_loader:
        output = torch.squeeze(model(random_trans(x)))
        optimizer.zero_grad()
        batch_loss = loss_function(output, y)
        batch_loss.backward()
        optimizer.step()

        loss += batch_loss.item()
        accuracy += get_batch_accuracy(output, y, train_N)
    if check_grad:
        logging.info('Last Gradient:')
        for param in model.parameters():
            logging.info(param.grad)
    logging.info('Train - Loss: {:.4f} Accuracy: {:.4f}'.format(loss, accuracy))


def validate(model, valid_loader, valid_N, loss_function):
    loss = 0
    accuracy = 0

    model.eval()
    with torch.no_grad():
        for x, y in valid_loader:
            output = torch.squeeze(model(x))

            loss += loss_function(output, y.float()).item()
            accuracy += get_batch_accuracy(output, y, valid_N)
    logging.info('Valid - Loss: {:.4f} Accuracy: {:.4f}'.format(loss, accuracy))


def make_prediction(file_path, pre_trans, model):
    image = Image.open(file_path)
    image = pre_trans(image).to(device)
    image = image.unsqueeze(0)
    output = model(image)
    prediction = output.item()
    return prediction


def load_model(cat_id, model_dir='data'):
	model_path = os.path.join(model_dir, f'{cat_id}.pth')
	model = vgg16(weights=None, num_classes=N_CLASSES)
	model_state_dict = torch.load(model_path, map_location=torch.device('cpu'))

	if next(iter(model_state_dict.keys())).startswith('0.'):
		new_state_dict = OrderedDict()
		for k, v in model_state_dict.items():
			name = k[2:]
			new_state_dict[name] = v
		model.load_state_dict(new_state_dict)
	else:
		model.load_state_dict(model_state_dict)

	return model


def discover_available_cat_ids(data_dir):
	cat_ids = []
	for entry in os.scandir(data_dir):
		if entry.is_file() and entry.name.endswith('.pth'):
			cat_id = os.path.splitext(entry.name)[0]
			cat_ids.append(cat_id)
	return cat_ids


@app.get('/train')
def train_model(cat_id: int):
	batch_size = 32
     
	# load the VGG16 network *pre-trained* on the ImageNet dataset
	weights = VGG16_Weights.DEFAULT
	vgg_model = vgg16(weights=weights)
	vgg_model.to(device)
	# Unfreeze the base model
	vgg_model.requires_grad_(True)

	cat_model = nn.Sequential(
		vgg_model,
		nn.Linear(1000, N_CLASSES)
	)

	cat_model.to(device)
	# compiling the model
	loss_function = nn.BCEWithLogitsLoss()
	optimizer = Adam(cat_model.parameters(), lr=.000001)
	cat_model = cat_model.to(device)
	# data augmentation
	pre_trans = weights.transforms()

	random_trans = transforms.Compose([
		transforms.RandomRotation(25),
		transforms.RandomResizedCrop((IMG_WIDTH, IMG_HEIGHT), scale=(.8, 1), ratio=(1, 1)),
		transforms.RandomHorizontalFlip(),
		transforms.ColorJitter(brightness=.2, contrast=.2, saturation=.2, hue=.2)
	])

	# train_path = f'data/{str(cat_id)}/train/'
	train_data = MyDataset(pre_trans, BUCKETS[0], n_img=[24, 140], is_train=True)
	train_loader = DataLoader(train_data, batch_size=batch_size, shuffle=True)
	train_N = len(train_loader.dataset)

	# valid_path = f'data/{str(cat_id)}/valid/'
	valid_data = MyDataset(pre_trans, BUCKETS[0], n_img=[6, 40], is_train=False)
	valid_loader = DataLoader(valid_data, batch_size=batch_size)
	valid_N = len(valid_loader.dataset)

	epochs = 4

	for epoch in range(epochs):
		logging.info('Epoch: {}'.format(epoch))
		train(
			cat_model,
			train_loader,
			train_N,
			random_trans,
			optimizer,
			loss_function,
			check_grad=False
		)
		validate(cat_model, valid_loader, valid_N, loss_function)
    
	data_dir = 'data'
	if not os.path.exists(data_dir):
		os.makedirs(data_dir)
	# After training, save the model
	torch.save(cat_model.state_dict(), os.path.join(data_dir, f'{str(cat_id)}.pth'))
	logging.info('Model saved as cat_model.pth')


@app.post('/predict')
async def predict(file: UploadFile = File(...)):
	weights = VGG16_Weights.DEFAULT
	pre_trans = weights.transforms()
    
	try:
		# Save the uploaded file temporarily
		file_path = f'/tmp/{file.filename}'
		with open(file_path, 'wb') as buffer:
			buffer.write(file.file.read())

		prediction = None
		# Load the model based on cat_id
		for cat_id in discover_available_cat_ids('data'):
			m = load_model(cat_id)

			# Make prediction using the uploaded file
			prediction = make_prediction(file_path, pre_trans, m)

			if prediction < 0:
				# Return the prediction as JSON
				return JSONResponse(content={'prediction': prediction, 'cat_id': cat_id})
		return JSONResponse(content={'prediction': prediction, 'cat_id': None})
      
	except Exception as e:
		return JSONResponse(status_code=500, content={'error': f'Prediction failed: {str(e)}'})


@app.get('/cats')
def cat_ids():
    return JSONResponse(content={'cat_ids': discover_available_cat_ids('data')})


@app.get('/')
def read_root():
	return {'message': 'Welcome to CatFinder API!'}

@app.get('/test')
def test():
    response = httpx.get(return_base_storage_url(BUCKETS[0], 'train/cat', 'cat_0.jpg'))
    return Image.open(BytesIO(response.content))
