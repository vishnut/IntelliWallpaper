from clarifai import rest
from clarifai.rest import ClarifaiApp
from clarifai.rest import Image as ClImage

app = ClarifaiApp()
model = app.models.get('general-v1.3')
image = ClImage(url='https://samples.clarifai.com/metro-north.jpg')
concepts = model.predict([image])["outputs"][0]["data"]["concepts"]

for concept in concepts:
    print(concept["name"], concept["value"])

#app.inputs.create_image_from_filename("images/27136_30859.jpg")
#print(vars(app.inputs.search_by_predicted_concepts(concepts=['traffic'])[1]))

#https://www.googleapis.com/customsearch/v1?key=AIzaSyCqtvK80bEAq-3PiNvqULaF4K0bxifOjsk&cx=012722929468578014313:dgpqijfnpfg&q=lectures

#AIzaSyCqtvK80bEAq-3PiNvqULaF4K0bxifOjsk