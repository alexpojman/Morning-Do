//
//  SettingsUITableViewController.swift
//  Morning-Do
//
//  Created by Alexander Pojman on 3/24/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import UIKit

class SettingsUITableViewController : UITableViewController {

    @IBOutlet weak var enablePushNotificationsCell: UITableViewCell!
    
    let rootRef     =   Firebase(url: "https://morning-do.firebaseio.com")
    let userRef     =   Firebase(url: "https://morning-do.firebaseio.com/users/")
    var settingsRef =   Firebase()
    
    override func viewDidLoad() {
        self.title = "SETTINGS"
        let enableNotificationsSwitch = UISwitch()
        enableNotificationsSwitch.addTarget(self, action: Selector("enableNotificationsStateChange:"), forControlEvents: UIControlEvents.ValueChanged)
        enablePushNotificationsCell.accessoryView = enableNotificationsSwitch
        
        self.settingsRef = Firebase(url: "https://morning-do.firebaseio.com/users/" + self.rootRef.authData.uid + "/settings")
        
        
        
        // Set all settings by firebase
        settingsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    for setting in snapshot.children.allObjects as! [FDataSnapshot] {
                        if (setting.key == "pushNotifications") {
                            if let state = setting.value as? Bool {
                                enableNotificationsSwitch.setOn(state, animated: false)
                            }
                        }
                    }
        })
        
    }
    
    func enableNotificationsStateChange(switchState: UISwitch) {
        // NSUserDefaults Update
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(switchState.on, forKey: "pushNotifications")
        
        // Firebase Settings Update
        self.settingsRef.updateChildValues(["pushNotifications": switchState.on])
        
        // Secondary implementation for local // TODO CHANGE THIS!
        if (switchState.on) {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        } else {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.None], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Logout") {
            rootRef.unauth()
        }
    }
}