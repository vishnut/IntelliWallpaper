//
//  PaperViewController.swift
//  IntelliWallpaper
//
//  Created by Vishnu Thiagarajan on 1/26/17.
//  Last Updated by Vishnu Thiagarajan on 2/18/18.
//  Copyright © 2018 Vishnu Thiagarajan. All rights reserved.
//

import Cocoa

class PaperViewController: NSViewController {

    let baseURL = "http://ec2-54-221-67-73.compute-1.amazonaws.com";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func thumbsUp(_ sender: NSButton) {
        
    }

    @IBAction func thumbsDown(_ sender: NSButton) {
    }
    
    func setWallpaper(wallpaperUrl: URL){
        let sharedWorkspace = NSWorkspace.shared
        let screens = NSScreen.screens
        
        for screen in screens{
            do{
                try sharedWorkspace.setDesktopImageURL(wallpaperUrl, for: screen )
            }
            catch {}
        }
    }
    
    @IBAction func nextWallpaper(_ sender: NSButton) {
        let url = URL(string: baseURL + "/random-good-image")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            // Return value of /random-good-image - Image URL
            let imgurl = URL(string: String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!);
            
            DispatchQueue.global().async {
                // Download image
                let data = try? Data(contentsOf: imgurl!)
                DispatchQueue.main.async {
                    // File path for saving images
                    let picturesURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
                    let uuid = UUID().uuidString
                    let fileURL = picturesURL.appendingPathComponent("intelliwallpaper/\(uuid).png")
                    
                    // Delete existing images in directory
                    let enumerator:FileManager.DirectoryEnumerator = FileManager.default.enumerator(atPath: picturesURL.appendingPathComponent("intelliwallpaper/").path)!
                    while let element = enumerator.nextObject() as? String {
                        if element.hasSuffix("jpg") || element.hasSuffix("png") {
                            let deleteURL = picturesURL.appendingPathComponent("intelliwallpaper/\(element)")
                            do {
                                try FileManager.default.removeItem(atPath: deleteURL.path);
                            }
                            catch let error as NSError {
                                print("File deltion failed for \(deleteURL.path): \(error)")
                            }
                        }
                    }
                    
                    // Save image
                    try? data?.write(to: fileURL)
                    
                    // Set wallpaper
                    self.setWallpaper(wallpaperUrl: fileURL)
                }
            }
        }
        
        task.resume()
    }
    
    @IBAction func helpClick(_ sender: NSButton) {
        // Open github repo in default browser
        let url = URL(string: "https://github.com/vishnut/IntelliWallpaper");
        NSWorkspace.shared.open(url!);
    }
}
