import requests
import os

def download_cat_photos(api_key, num_photos=10):
    """Downloads cat photos from The Cat API and saves them to an 'images' folder.

    Args:
        api_key: Your API key for The Cat API.
        num_photos: The number of photos to download.
    """

    # Create the 'images' folder if it doesn't exist
    if not os.path.exists("images"):
        os.makedirs("images")

    url = "https://api.thecatapi.com/v1/images/search"
    headers = {"x-api-key": api_key}
    params = {"mime_types": "jpg"}

    for i in range(num_photos):
        # Request a cat image URL
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()  # Raise an error for bad responses

        data = response.json()
        image_url = data[0]["url"]

        # Download and save the image
        image_response = requests.get(image_url)
        image_response.raise_for_status()

        file_path = os.path.join("images", f"cat_{i}.jpg")

        with open(file_path, 'wb') as f:
            f.write(image_response.content)

        print(f"Downloaded image {i+1}/{num_photos}")

if __name__ == "__main__":
    api_key = "live_1EPvNF1B6wAI01JQBLT6Bo9x4UdT6lZGHA5o7NAhwoYNX2kvDbxQKRuRhIr2lysc"
    download_cat_photos(api_key)
    print("Download complete!")