//
//  RegisterViewController.swift
//  Morning-Do
//
//  Created by Alexander Pojman on 2/2/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    let promptCategoriesRef = Firebase(url: "https://morning-do.firebaseio.com/prompts")
    let usersRef = Firebase(url: "https://morning-do.firebaseio.com/users")
    
    @IBAction func Finish(sender: UIButton) {
        registerUser()
    }
    
    override func viewDidLoad() {
        self.usernameTextField.delegate = self;
        self.passwordTextField.delegate = self;
        self.passwordConfirmTextField.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    func registerUser() {
        let ref = Firebase(url: "https://morning-do.firebaseio.com")
        
        // Validate Stuff
        let validEmail = validateEmail(usernameTextField.text!)
        let validPassword = validatePassword(passwordTextField.text!, passwordConfirm: passwordConfirmTextField.text!)
        
        if(validEmail == true && validPassword == true) {
            ref.createUser(usernameTextField.text, password: passwordTextField.text,
                withValueCompletionBlock: { error, result in
                    
                    if error != nil {
                        print("Register User Failed")
                    } else {
                        let uid = result["uid"] as? String
                        print("Successfully created user account with uid: \(uid)")
                        
                        // Once user is registered, create new user defaults in firebase
                        let userCategoriesRef = Firebase(url: "https://morning-do.firebaseio.com/users/" + uid! + "/categories")
                        
                        
                        self.promptCategoriesRef.observeEventType(.Value, withBlock: { snapshot in
                            
                            for (childSnapshot) in snapshot.children {
                                if let categoryName = childSnapshot.key {
                                    userCategoriesRef.updateChildValues([categoryName!: false])
                                }
                            }
                            
                            }, withCancelBlock: { error in
                                print(error.description)
                        })
                        
                        // Log user in
                        ref.authUser(self.usernameTextField.text, password: self.passwordTextField.text,
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
            })
        } else {
            print("Register User Failed")
        }
    }
    
    // MARK: Validation Methods
    func validateEmail(email: String) -> Bool {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if (emailTest.evaluateWithObject(email) == false) {
            showErrorAlert("Incorrect Email Format")
        }
        
        return emailTest.evaluateWithObject(email)
        
    }
    
    func validatePassword(password: String, passwordConfirm: String) -> Bool {
        var isValid = false
        let validLength = password.characters.count >= 8
        
        if (!validLength) {
            // throw some error
            showErrorAlert("Password Should Be At Least 8 Characters")
        }
        
        if (validLength && password == passwordConfirm) {
            isValid = true
        }
        
        return isValid
    }
    
    func showErrorAlert(error: String) {
        
        // create the alert
        let alert = UIAlertController(title: "Issue Logging In", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: UITextField Delegation Methods
    
    /**
    * Called when 'return' key pressed. return NO to ignore.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == self.usernameTextField) {
            self.passwordTextField.becomeFirstResponder()
        } else if (textField == self.passwordTextField) {
            self.passwordConfirmTextField.becomeFirstResponder()
        } else if (textField == self.passwordConfirmTextField) {
            registerUser()
        }
        
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}