//
//  LoginViewController.swift
//  Morning-Do
//
//  Created by Alex Pojman on 2/3/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LandingPageViewController : UIViewController {
    let ref = Firebase(url: "https://morning-do.firebaseio.com")
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoView: UIImageView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = true
        
        signUpButton.layer.cornerRadius = 10.0
        loginButton.layer.cornerRadius = 10.0
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
       // logoView.animationImages = self.logoImages
       // logoView.animationDuration = 0.5;
        //logoView.startAnimating()
        
        // If Auto-Login
       /* if (ref.authData.uid != nil) {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }*/
        
        if (ref.authData != nil) {
            //usernameTextField.text = ref.authData.providerData["email"] as? NSString as? String
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
}
