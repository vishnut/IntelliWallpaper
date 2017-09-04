import json

data = []
with open('good_images.json') as f:
    data.extend(json.load(f))
    print('Good Images  {0}'.format(len(data)))
with open('bad_images.json') as f:
    bad_data = json.load(f)
    print('Bad Images   {0}'.format(len(bad_data)))
    data.extend(bad_data)
print('Total Images {0}'.format(len(data)))
