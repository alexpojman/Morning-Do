//
//  ViewController.swift
//  Morning-Do
//
//  Created by Alexander Pojman on 1/28/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, MDScratchImageViewDelegate {

    @IBOutlet weak var promptOfDay: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var scratchOffView: MDScratchImageView!
    
    let rootRef     =   Firebase(url: "https://morning-do.firebaseio.com")
    let awardRef    =   Firebase(url: "https://morning-do.firebaseio.com/awards")
    let promptsRef  =   Firebase(url: "https://morning-do.firebaseio.com/prompts")
    var userRef     =   Firebase()
    var categoriesRef = Firebase()
    
    var categories  =   [String]()
    var prompts = [Prompt]()
    var scratchOffFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scratchOffView.delegate = self
        self.scratchOffView.setImage(UIImage(named: "TodayIWill"), radius: 200)
        
        // Set Firebase references
        userRef = Firebase(url: "https://morning-do.firebaseio.com/users/" + self.rootRef.authData.uid)
        categoriesRef = Firebase(url: "https://morning-do.firebaseio.com/users/" + self.rootRef.authData.uid + "/categories")
        
        // Ask for notification permission
        self.registerLocal()
        
        // TODO: Check if today has been revealed
        if (self.scratchOffFinished == true) {
            self.scratchOffView.hidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.getUserCategories()
     }

    // Get all prompts for specified categories
    func getPromptsForCategories(categories: [String]) {
        self.prompts.removeAll()
        promptsRef.observeEventType (.Value, withBlock: { snapshot in
            
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                if(self.categories.contains(rest.key)) {
                    for restChild in rest.children.allObjects as! [FDataSnapshot] {
                        let newPrompt = Prompt.init(Description: restChild.value as! String, Index: Int(restChild.key)!, Category: rest.key as String)
                        self.prompts.append(newPrompt);
                    }
                }
            }
        })
        
    }
    
    func getUserCategories() {
        self.categories.removeAll()
        categoriesRef.observeEventType (.Value, withBlock: { snapshot in
            for category in snapshot.children.allObjects as! [FDataSnapshot] {
                if (String(category.value) == "1") {
                    self.categories.append(category.key)
                }
            }
            
            self.getPromptsForCategories(self.categories)
        })
        
        self.getPromptsForCategories(self.categories)
    }

    @IBAction func onButtonTouch(sender: UIButton) {
        let randomInt = randRange(0, upper: self.prompts.count - 1)
        self.promptOfDay.text = self.prompts[randomInt].description
        
        let currentPromptPath = self.prompts[randomInt].category + "/" + String(self.prompts[randomInt].index)
        userRef.updateChildValues(["currentPrompt": currentPromptPath])
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func mdScratchImageView(scratchImageView: MDScratchImageView!, didChangeMaskingProgress maskingProgress: CGFloat) {
        
        if (maskingProgress > 0.85 && self.scratchOffFinished == false) {
            scratchOffFinished = true;
            
            UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                    self.scratchOffView.alpha = 0.0
                
                }, completion: { (finished: Bool) -> Void in
                    self.scratchOffView.hidden = true
            })
        }
    }
    
    @IBAction func sendNotification(sender: UIButton) {
        // Check if permission is granted for local notifications
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let today = NSDate()
        let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(
            .Minute,
            value: 1,
            toDate: today,
            options: NSCalendarOptions(rawValue: 0))
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = tomorrow
        print(localNotification.fireDate)
        localNotification.alertBody = "Wake up to a brand new Morning Do!"
        localNotification.alertAction = "view!"
        localNotification.timeZone = NSTimeZone.localTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func registerLocal() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
}

