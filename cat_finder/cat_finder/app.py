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

import glob
from PIL import Image


app = FastAPI()

# check if has gpu avalable
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

N_CLASSES = 1
IMG_WIDTH, IMG_HEIGHT = (224, 224)
DATA_LABELS = ['is_the_cat', 'isnt_the_cat'] 
    
class MyDataset(Dataset):
    def __init__(self, data_dir, pre_trans):
        self.imgs = []
        self.labels = []
        
        for l_idx, label in enumerate(DATA_LABELS):
            data_paths = glob.glob(data_dir + label + '/*.jpg', recursive=True)
            for path in data_paths:
                img = Image.open(path)
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
        print('Last Gradient:')
        for param in model.parameters():
            print(param.grad)
    print('Train - Loss: {:.4f} Accuracy: {:.4f}'.format(loss, accuracy))


def validate(model, valid_loader, valid_N, loss_function):
    loss = 0
    accuracy = 0

    model.eval()
    with torch.no_grad():
        for x, y in valid_loader:
            output = torch.squeeze(model(x))

            loss += loss_function(output, y.float()).item()
            accuracy += get_batch_accuracy(output, y, valid_N)
    print('Valid - Loss: {:.4f} Accuracy: {:.4f}'.format(loss, accuracy))


def make_prediction(file_path, pre_trans, model):
    image = Image.open(file_path)
    image = pre_trans(image).to(device)
    image = image.unsqueeze(0)
    output = model(image)
    prediction = output.item()
    return prediction


def load_model(cat_id, model_dir='data'):
    model_path = os.path.join(model_dir, cat_id, 'cat_model.pth')
    model = vgg16(pretrained=False, num_classes=N_CLASSES)
    model.load_state_dict(torch.load(model_path))
    return model


def discover_available_cat_ids(data_dir):
    cat_ids = []
    for entry in os.scandir(data_dir):
        if entry.is_dir():
            cat_id = entry.name
            model_path = os.path.join(data_dir, cat_id, 'cat_model.pth')
            if os.path.isfile(model_path):
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

	train_path = f'data/{str(cat_id)}/train/'
	train_data = MyDataset(train_path, pre_trans)
	train_loader = DataLoader(train_data, batch_size=batch_size, shuffle=True)
	train_N = len(train_loader.dataset)

	valid_path = f'data/{str(cat_id)}/valid/'
	valid_data = MyDataset(valid_path, pre_trans)
	valid_loader = DataLoader(valid_data, batch_size=batch_size)
	valid_N = len(valid_loader.dataset)

	epochs = 2

	for epoch in range(epochs):
		print('Epoch: {}'.format(epoch))
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
    
	# After training, save the model
	torch.save(cat_model.state_dict(), f'data/{str(cat_id)}/cat_model.pth')
	print('Model saved as cat_model.pth')


@app.post('/predict')
async def predict(file: UploadFile = File(...)):
	weights = VGG16_Weights.DEFAULT
	pre_trans = weights.transforms()
    
	try:
		# Save the uploaded file temporarily
		file_path = f'/tmp/{file.filename}'
		with open(file_path, 'wb') as buffer:
			buffer.write(file.file.read())

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
