# IntelliWallpaper
Are you bored of your wallpaper? Windows users get to see always see new and beautiful images in their lock screen. Without having to download gigabytes of images, it would be nice to have different wallpapers taken from the internet and set automatically everyday on Macs. 

This script will download National Geographic's Photo of the Day and change your wallpaper. 

Of course, since we want it to run automatically, we also will need to create a cron job using crontab. You can read more about crontab [here](https://ole.michelsen.dk/blog/schedule-jobs-with-crontab-on-mac-osx.html). However, if want it to simply change your wallpaper once a day, you can just follow these instructions.

## Setup

Begin by opening terminal and opening the job list with an editor. For simplicity, we will use nano here.

`env EDITOR=nano crontab -e`

Type in the following:

`*/180 * * * *  sh /path/to/file/IntelliWallpaper/natgeowall.sh`

Of course, replace /path/to/file will the path to the IntelliWallpaper folder. For example, if you have the folder saved in Documents, you can type in "~/Documents/IntelliWallpaper/natgeowall.sh". 180 represents the time between runs. This job will run every 3 hours and ensure that the wallpaper is set to the one for that day. You can change the values if you want or maybe even set a particular time at which you want the script to run. 

To save and exit, press CTRL+O (capital o, not 0) to save followed by enter and then CTRL+X to exit. To check that the cron job has been added properly, type:

`crontab -l`

The job should appear there.

## Issues
Apple doesn't like setting a wallpaper with the same name in the same location. If you log out and log back in, macOS will check the location again. For example, if your background is currently called picture1.jpg and you want to use a different image but you want to store it there with the same name, even if you switch your wallpaper to picture2.jpg and then replace picture1.jpg and try to change your wallpaper to the new picture1.jpg, your wallpaper will be changed to the old picture1.jpg. When you log out and log back in, your background will automatically be set to the new image. There are ways to use this to your advantage but there are problems with this too. I'm still working on changing this repo so that I can use it without having to use different file names every time. Or maybe I'll just delete existing images and randomize the downloaded names so that it will be getting an old image is improbable enough.

## Next Steps
This script is meant to learn what you like and use that to frequently change your wallpaper. Of course, the first step in this process is to be able to automate the changing of wallpapers. That is now done. The next step would be to take feedback and tune the script to pick images based on feedback. The challenge there is that the images must still be of high quality and I will need a source that will both always have fresh images and be large enough that I can filter based on categories. I am considering using a Google Image Search with filters on size and time. That will require a lot more work but for now, I can enjoy pretty wallpapers everyday.
