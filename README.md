# IntelliWallpaper v2.0

![IntelliWallpaper](https://raw.githubusercontent.com/vishnut/IntelliWallpaper/master/macos/IntelliWallpaper/Assets.xcassets/AppIcon.appiconset/icon_256x256.png "IntelliWallpaper")

IntelliWallpaper attempts to automate the process of getting beautiful wallpapers everyday. Data is collected on app usage and from user input on the training page at [http://ec2-54-221-67-73.compute-1.amazonaws.com](http://ec2-54-221-67-73.compute-1.amazonaws.com). This data is then fed into multiple machine learning models so that the models can extract features that make up a good wallpaper. Once the models learn what images are "good wallpapers", other new models will attempt to personalize the wallpapers for each user based on past usage data on the app.

## Setup

Setup on v2 is simple. Clone the repository. The application binary will be present as IntelliWallpaper.app. You can move that to your Applications directory and run it. The rest of the files from the cloned repository can be deleted. 

## Issues

Images are currently stored in the Pictures directory under an "intelliwallpaper" directory. For now, the application assumes that such a directory exists and will fail if it does not. For first time setup, until this issue is resolved, simply create a folder called "intelliwallpaper" in the Pictures directory.

## Changes from v1

Version 1 used scripts to pull wallpapers from image sources such as National Geographic. Those scripts are still available under the [scripts directory](https://github.com/vishnut/IntelliWallpaper/tree/master/scripts). There were several problems with this approach. Most notably, you could often only get one image a day. That limitation no longer exists in v2. Additionally, there was no machine learning or personalization. 

## Next Steps

Machine learning models will need to be improved along with an increase in data collection. The planned approach right now is to use custom built models along with Clarif.ai to tag images first. At this step, the results of all of these models can be combined and passed into another model to distinguish good wallpapers from bad wallpapers. However, instead of this, if sufficient data exists, we could simply output images from the training curated list but personalize based on automated tags. Experimentation needed.
