//
//  LoginScreenViewController.swift
//  Morning-Do
//
//  Created by Alexander Pojman on 2/13/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import UIKit

class LoginScreenViewController: UIViewController {
    let ref = Firebase(url: "https://morning-do.firebaseio.com")
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func viewdidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = true;
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        ref.authUser(usernameTextField.text, password: passwordTextField.text,
            withCompletionBlock: { error, authData in
                if error != nil {
                    // There was an error logging in to this account
                    print("Login failed")
                } else {
                    // We are now logged in
                    self.performSegueWithIdentifier("LoginSegue", sender: self)
                }
        })
    }
    
    // MARK: Validation Methods
    func validateEmail(email: String) -> Bool {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if (emailTest.evaluateWithObject(email) == false) {
            //showErrorAlert("Incorrect Email Format")
        }
        
        return emailTest.evaluateWithObject(email)
        
    }
}