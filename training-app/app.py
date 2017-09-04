from flask import Flask, redirect, render_template, url_for
import config
import json
import os.path
import requests

app = Flask(__name__)

class CrowdImages:
    def __init__(self):
        self.page_num = 1
        self.curated_images = self.get_curated_images()
        self.good_images = []
        self.bad_images = []

    def get_curated_images(self):
        r = requests.get("https://api.unsplash.com/photos/random?orientation=landscape&count=10&client_id={0}".format(config.API_KEY))
        return r.json()

    def load_curated_images(self):
        self.curated_images = self.get_curated_images()    

    def __iter__(self):
        while 1:  # get number of pages in the future
            yield from self.curated_images
            self.load_curated_images()

images = CrowdImages()
images_list = iter(images)
current_image = None

@app.route('/')
def index():
    global current_image
    if images_list:
        current_image = next(images_list)
    user_name = current_image['user']['name']
    image_url = current_image['urls']['raw']
    user_link = current_image['user']['links']['html'] + '?utm_source=intelliWallpaper&utm_medium=referral&utm_campaign=api-credit'
    return render_template('index.html', name=user_name, image=image_url, link=user_link)

@app.route('/load_curated')
def load_images():
    global images_list
    images.load_curated_images()
    images_list = iter(images)
    return json.dumps(images.curated_images)

def write_out_votes(image_votes, file_name):
    if os.path.isfile('/home/ubuntu/IntelliWallpaper/' + file_name):
        with open('/home/ubuntu/IntelliWallpaper/' + file_name) as f:
            data = json.load(f)
            if data:
                images_votes.extend(data)
    with open('/home/ubuntu/IntelliWallpaper/' + file_name, 'w') as f:
        json.dump(images_votes, f)

@app.route('/thumbs-up/', methods=['POST'])
def good_image():
    images.good_images.append(current_image)
    if len(images.good_images) > 10:
        write_out_votes(images.bad_images, 'good_images.json')
    images.good_images = []
    return redirect(url_for('index', region=None, ip=None))

@app.route('/thumbs-down/', methods=['POST'])
def bad_image():
    images.bad_images.append(current_image)
    if len(images.bad_images) > 10:
        write_out_votes(images.bad_images, 'bad_images.json')
    images.bad_images = []
    return redirect(url_for('index', region=None, ip=None))


if __name__ == "__main__":
    app.debug = True
    app.run()

