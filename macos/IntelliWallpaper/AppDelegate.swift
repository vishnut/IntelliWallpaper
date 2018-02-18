//
//  AppDelegate.swift
//  IntelliWallpaper
//
//  Created by Vishnu Thiagarajan on 1/26/17.
//  Copyright © 2017 Vishnu Thiagarajan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength: -2)
    let popover = NSPopover()
    let menu = NSMenu()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "StatusBarButtonImage"))
            button.action = #selector(togglePopover(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        popover.contentViewController = PaperViewController(nibName: NSNib.Name(rawValue: "PaperViewController"), bundle: nil)
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    @objc func togglePopover(sender: AnyObject?) {
        let event = NSApp.currentEvent!;
        if event.type == NSEvent.EventType.rightMouseUp {
            statusItem.popUpMenu(menu);
        } else {
            if popover.isShown {
                closePopover(sender: sender)
            } else {
                showPopover(sender: sender)
            }
        }
    }
    
}

