//
//  IntroViewController.swift
//  Morning-Do
//
//  Created by Alexander Pojman on 4/18/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import RazzleDazzle
import AudioToolbox
import Firebase

class IntroViewController: AnimatedPagingScrollViewController {
    //
    // MARK: Subview Declarations
    //
    private let pageControl =                   UIPageControl()
    private let iphone =                        UIImageView(image: UIImage(named: "iPhone"))
    private let label =                         UILabel()
    private let getStartedButton =              UIButton()
    private let bottomCover =                   UIView()
    
    private let usernameTextField =             UITextField()
    private let passwordTextField =             UITextField()
    private let confirmPasswordTextField =      UITextField()
    private let resetPasswordButton =           UIButton()
    private let submitButton =                  UIButton()
    private let switchLoginRegisterButton =     UIButton()
    
    private let validationUsernameLabel =        UILabel()
    private let validationPasswordLabel =        UILabel()
    private let validationConfirmPasswordLabel = UILabel()
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    enum validationErrorType {
        case LoginIncorrect
        case PasswordsDontMatch
        case PasswordTooShort
        case UsernameTaken
        case EmailNotValid
        case NoInternetConnection
        case PasswordResetFailed
    }
    
    //
    // MARK: Firebase Refs
    //
    let ref =                               Firebase(url: "https://morning-do.firebaseio.com")
    let promptCategoriesRef =               Firebase(url: "https://morning-do.firebaseio.com/prompts")
    let usersRef =                          Firebase(url: "https://morning-do.firebaseio.com/users")
    
    //
    // MARK: Misc Declarations
    //
    private var isLoginView =               false
    
    //
    // MARK: Initialization Methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 242.0/255.0, green: 160.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        
        // TODO: change name for purpose of dismiss keyboard
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(IntroViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        
        configureViews()
        configureAnimations()
    }
    
    override func numberOfPages() -> Int {
        return 4
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        // Changing Page Control Current Page Indicator
        if (scrollView.contentOffset.x > (CGFloat(self.pageControl.currentPage) * self.pageWidth) + (self.pageWidth / 2)) {
            self.pageControl.currentPage += 1
        } else if (scrollView.contentOffset.x < (CGFloat(self.pageControl.currentPage) * self.pageWidth) - (self.pageWidth / 2)) {
            self.pageControl.currentPage -= 1
        }
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    // Add Views to Content View
    private func configureViews() {
        activityIndicator.center = view.center
        // Determines the "Order" of the views (first is in the back)
        contentView.addSubview(iphone)
        contentView.addSubview(label)
        contentView.addSubview(bottomCover)
        contentView.addSubview(pageControl)
        contentView.addSubview(getStartedButton)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(submitButton)
        contentView.addSubview(resetPasswordButton)
        contentView.addSubview(switchLoginRegisterButton)
        contentView.addSubview(validationUsernameLabel)
        contentView.addSubview(validationPasswordLabel)
        contentView.addSubview(validationConfirmPasswordLabel)
        contentView.addSubview(activityIndicator)
    }
    
    // Configure Animation and Properties for Added Subviews
    private func configureAnimations() {
        configureiPhone()
        configureLabels()
        configureBottomCover()
        configurePageControl()
        configureTextFields()
        configureButtons()
    }
    
    
    //
    // MARK: Subview Configurations
    //
    private func configureiPhone() {
        NSLayoutConstraint(item: iphone, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1, constant: 0).active = true
        keepView(iphone, onPages: [0, 2])
        
        let scaleAnimation = ScaleAnimation(view: iphone)
        scaleAnimation[0] = 0.75
        animator.addAnimation(scaleAnimation)
    }
    
    private func configureLabels() {
        label.alpha = 0
        label.text = "Works for sure"
        contentView.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 0.75, constant: 0))
        keepView(label, onPages: [0, 2])
        
        // Fade in Animation
        let alphaAnimation = AlphaAnimation(view: label)
        alphaAnimation[0] = 0
        alphaAnimation[1.2] = 1
        animator.addAnimation(alphaAnimation)
        
        
        // Scale Animation
        let labelScaleAnimation = ScaleAnimation(view: label)
        labelScaleAnimation[1.2] = 1
        labelScaleAnimation[1.8] = 1.6
        animator.addAnimation(labelScaleAnimation)
        
        //
        // Validation Labels
        //
        validationUsernameLabel.textAlignment = .Center
        validationUsernameLabel.alpha = 0.0
        validationUsernameLabel.text = ""
        validationUsernameLabel.textColor = UIColor.redColor()
        NSLayoutConstraint(item: validationUsernameLabel, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 0.6, constant: 0).active = true
        NSLayoutConstraint(item: validationUsernameLabel, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.8, constant: 0).active = true
        keepView(validationUsernameLabel, onPage: 3)
        
        validationPasswordLabel.textAlignment = .Center
        validationPasswordLabel.alpha = 0.0
        validationPasswordLabel.text = ""
        validationPasswordLabel.textColor = UIColor.redColor()
        NSLayoutConstraint(item: validationPasswordLabel, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 0.8, constant: 0).active = true
        NSLayoutConstraint(item: validationPasswordLabel, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.8, constant: 0).active = true
        keepView(validationPasswordLabel, onPage: 3)
        
        validationConfirmPasswordLabel.textAlignment = .Center
        validationConfirmPasswordLabel.alpha = 0.0
        validationConfirmPasswordLabel.text = ""
        validationConfirmPasswordLabel.textColor = UIColor.redColor()
        NSLayoutConstraint(item: validationConfirmPasswordLabel, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: validationConfirmPasswordLabel, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.8, constant: 0).active = true
        keepView(validationConfirmPasswordLabel, onPage: 3)
        
    }
    
    private func configureBottomCover() {
        bottomCover.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 195.0/255.0, alpha: 1.0)
        NSLayoutConstraint(item: bottomCover, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.75, constant: 0).active = true
        NSLayoutConstraint(item: bottomCover, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: bottomCover, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.5, constant: 0).active = true
        keepView(bottomCover, onPages: [0, 2.0])
    }
    
    private func configurePageControl() {
        pageControl.numberOfPages = numberOfPages()
        pageControl.pageIndicatorTintColor = UIColor.blackColor()
        
        NSLayoutConstraint(item: pageControl, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 0.9, constant: 0).active = true
        keepView(pageControl, onPages: [0, 2])
    }
    
    private func configureTextFields() {
        
        //
        // Username
        //
        usernameTextField.placeholder = "Username"
        usernameTextField.textAlignment = .Center
        usernameTextField.borderStyle = .RoundedRect
        NSLayoutConstraint(item: usernameTextField, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 0.7, constant: 0).active = true
        NSLayoutConstraint(item: usernameTextField, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.8, constant: 0).active = true
        keepView(usernameTextField, onPage: 3)
        
        
        //
        // Password
        //
        passwordTextField.placeholder = "Password"
        passwordTextField.textAlignment = .Center
        passwordTextField.borderStyle = .RoundedRect
        passwordTextField.secureTextEntry = true
        NSLayoutConstraint(item: passwordTextField, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 0.9, constant: 0).active = true
        NSLayoutConstraint(item: passwordTextField, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.8, constant: 0).active = true
        keepView(passwordTextField, onPage: 3)
        
        //
        // Confirm Password
        //
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.textAlignment = .Center
        confirmPasswordTextField.borderStyle = .RoundedRect
        confirmPasswordTextField.secureTextEntry = true
        NSLayoutConstraint(item: confirmPasswordTextField, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.1, constant: 0).active = true
        NSLayoutConstraint(item: confirmPasswordTextField, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.8, constant: 0).active = true
        keepView(confirmPasswordTextField, onPage: 3)
    }
    
    private func configureButtons() {
        
        //
        // Get Started
        //
        getStartedButton.setTitle("GET STARTED", forState: .Normal)
        NSLayoutConstraint(item: getStartedButton, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 0.95, constant: 0).active = true
        NSLayoutConstraint(item: getStartedButton, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.4, constant: 0).active = true
        keepView(getStartedButton, onPages: [0,2])
        getStartedButton.addTarget(self, action: #selector(getStartedTapped(_:)), forControlEvents: .TouchUpInside)
        
        //
        // Submit
        //
        submitButton.setTitle("REGISTER", forState: .Normal)
        NSLayoutConstraint(item: submitButton, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.3, constant: 0).active = true
        NSLayoutConstraint(item: submitButton, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.9, constant: 0).active = true
        keepView(submitButton, onPage: 3)
        submitButton.addTarget(self, action: #selector(IntroViewController.tryRegister(_:)), forControlEvents: .TouchUpInside)
        
        //
        // Reset Password
        //
        resetPasswordButton.setTitle("Reset Password", forState: .Normal)
        resetPasswordButton.hidden = true
        NSLayoutConstraint(item: resetPasswordButton, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1.5, constant: 0).active = true
        NSLayoutConstraint(item: resetPasswordButton, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.9, constant: 0).active = true
        keepView(resetPasswordButton, onPage: 3)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordTapped(_:)), forControlEvents: .TouchUpInside)
        
        // Switch Login/RegisterView
        switchLoginRegisterButton.setTitle("Have An Acount? Login", forState: .Normal)
        NSLayoutConstraint(item: switchLoginRegisterButton, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 0.9, constant: 0).active = true
        NSLayoutConstraint(item: switchLoginRegisterButton, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.8, constant: 0).active = true
        keepView(switchLoginRegisterButton, onPage: 3)
        switchLoginRegisterButton.addTarget(self, action: #selector(switchLoginRegisterView(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    //
    // MARK: Validation Methods
    //
    func validateEmail(email: String) -> Bool {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if (emailTest.evaluateWithObject(email) == false) {
            showValidationError(.EmailNotValid)
        }
        
        return emailTest.evaluateWithObject(email)
        
    }
    
    func validatePasswordForRegister(password: String, passwordConfirm: String) -> Bool {
        var isValid = false
        let validLength = password.characters.count >= 8
        
        if (!validLength) {
            showValidationError(.PasswordTooShort)
        } else if (validLength && password == passwordConfirm) {
            isValid = true
        } else {
            showValidationError(.PasswordsDontMatch)
        }
        
        return isValid
    }
    
    //
    // MARK: Login/Register Methods
    //
    func tryLogin(sender:UIButton) {
        activityIndicator.startAnimating()
        ref.authUser(usernameTextField.text, password: passwordTextField.text,
                     withCompletionBlock: { error, authData in
                        self.activityIndicator.stopAnimating()
                        if error != nil {
                            // There was an error logging in to this account
                            print("Login failed")
                            
                            self.showValidationError(.LoginIncorrect)
                        } else {
                            // We are now logged in
                            self.performSegueWithIdentifier("LoginSegue", sender: self)
                        }
        })
    }
    
    func tryRegister(sender:UIButton) {
        
        // Validate Stuff
        let validEmail = validateEmail(usernameTextField.text!)
        let validPassword = validatePasswordForRegister(passwordTextField.text!, passwordConfirm: confirmPasswordTextField.text!)
        if (validEmail == true && validPassword) {
            
            ref.createUser(usernameTextField.text, password: passwordTextField.text,
                           withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                
                                if let errorCode = FAuthenticationError(rawValue: error.code) {
                                    switch (errorCode) {
                                    case .EmailTaken:
                                        self.showValidationError(.UsernameTaken)
                                    case .InvalidEmail:
                                        print("Handle invalid email")
                                    case .InvalidPassword:
                                        print("Handle invalid password")
                                    case .NetworkError:
                                        self.showValidationError(.NoInternetConnection)
                                    default:
                                        print(errorCode)
                                    }
                                }
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
                                self.ref.authUser(self.usernameTextField.text, password: self.passwordTextField.text,
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
    
    //
    // MARK: Button Selectors
    //
    func switchLoginRegisterView(sender:UIButton) {
        resetValidationLabels()
        isLoginView = !isLoginView
        
        passwordTextField.hidden = false
        
        if (isLoginView) {
            switchLoginRegisterButton.setTitle("Need An Account? Register", forState: .Normal)
            confirmPasswordTextField.hidden = true;
            resetPasswordButton.hidden = false;
            resetPasswordButton.setTitle("Reset Password", forState: .Normal)
            submitButton.setTitle("LOGIN", forState: .Normal)
            submitButton.removeTarget(self, action: #selector(tryRegister(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            submitButton.addTarget(self, action: #selector(tryLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        } else if (!isLoginView) {
            switchLoginRegisterButton.setTitle("Already Have An Account? Sign in", forState: .Normal)
            confirmPasswordTextField.hidden = false;
            resetPasswordButton.hidden = true;
            submitButton.setTitle("REGISTER", forState: .Normal)
            submitButton.removeTarget(self, action: #selector(tryLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            submitButton.addTarget(self, action: #selector(tryRegister(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func getStartedTapped(sender:UIButton) {
        scrollView.setContentOffset(CGPointMake(CGFloat(self.numberOfPages() - 1) * self.pageWidth, 0), animated: true)
    }
    
    func resetPasswordTapped(sender:UIButton) {
        // Hide all but email
        passwordTextField.hidden = true
        submitButton.setTitle("Confirm Reset", forState: .Normal)
        submitButton.removeTarget(self, action: #selector(tryLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        submitButton.addTarget(self, action: #selector(confirmResetPassword(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        resetPasswordButton.setTitle("Cancel", forState: .Normal)
        resetPasswordButton.removeTarget(self, action: #selector(resetPasswordTapped(_:)), forControlEvents: .TouchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(cancelResetPassword(_:)), forControlEvents: .TouchUpInside)
    }
    
    func confirmResetPassword(sender:UIButton) {
        // Actually use firebase to send reset password link
        
        // Reset to login
        ref.resetPasswordForUser(usernameTextField.text, withCompletionBlock: { error in
            if error != nil {
                // There was an error processing the request
            } else {
                // Password reset sent successfully
                // Change to Login View
                self.passwordTextField.hidden = false
                self.submitButton.setTitle("LOGIN", forState: .Normal)
                self.submitButton.removeTarget(self, action: #selector(self.confirmResetPassword(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.submitButton.addTarget(self, action: #selector(self.tryLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.resetPasswordButton.setTitle("Reset Password", forState: .Normal)
                self.resetPasswordButton.removeTarget(self, action: #selector(self.cancelResetPassword(_:)), forControlEvents: .TouchUpInside)
                self.resetPasswordButton.addTarget(self, action: #selector(self.resetPasswordTapped(_:)), forControlEvents: .TouchUpInside)
                
                // Prompt user to change password after logging in
            }
        })
    }
    
    func cancelResetPassword(sender:UIButton) {
        passwordTextField.hidden = false
        resetPasswordButton.removeTarget(self, action: #selector(cancelResetPassword(_:)), forControlEvents: .TouchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordTapped(_:)), forControlEvents: .TouchUpInside)
        resetPasswordButton.setTitle("Reset Password", forState: .Normal)
        
        submitButton.setTitle("LOGIN", forState: .Normal)
        submitButton.removeTarget(self, action: #selector(confirmResetPassword(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        submitButton.addTarget(self, action: #selector(tryLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // 
    // Handle Errors
    //
    
    func showValidationError(error: validationErrorType) {
        
        switch error {
        case .LoginIncorrect:
            
            // Vibrate and Shake
            self.usernameTextField.shake(true)
            self.passwordTextField.shake(true)
            
            validationUsernameLabel.text = "Incorrect Login Information"
            validationUsernameLabel.fadeIn(0.5, delay: 0.0, completion: {(finished: Bool) -> Void in
                self.validationUsernameLabel.fadeOut(0.75, delay: 2.5)
            })
            break
        case .PasswordsDontMatch:
            self.confirmPasswordTextField.shake(true)
            
            validationConfirmPasswordLabel.text = "Passwords Do Not Match"
            validationConfirmPasswordLabel.fadeIn(0.5, delay: 0.0, completion: {(finished: Bool) -> Void in
                self.validationConfirmPasswordLabel.fadeOut(0.75, delay: 2.5)
            })
            break
        case .PasswordTooShort:
            self.passwordTextField.shake(true)
            validationPasswordLabel.text = "Must Be At Least 8 Characters"
            validationPasswordLabel.fadeIn(0.5, delay: 0.0, completion: {(finished: Bool) -> Void in
                self.validationPasswordLabel.fadeOut(0.75, delay: 2.5)
            })
            break
        case .UsernameTaken:
            self.usernameTextField.shake(true)
            validationUsernameLabel.text = "Email Already Taken"
            validationUsernameLabel.fadeIn(0.5, delay: 0.0, completion: {(finished: Bool) -> Void in
                self.validationUsernameLabel.fadeOut(0.75, delay: 2.5)
            })
            break
        case .EmailNotValid:
            self.usernameTextField.shake(true)
            validationUsernameLabel.text = "Not A Valid Email"
            validationUsernameLabel.fadeIn(0.5, delay: 0.0, completion: {(finished: Bool) -> Void in
                self.validationUsernameLabel.fadeOut(0.75, delay: 2.5)
            })
            break
        case .NoInternetConnection:
            print ("No network available")
            break
        case .PasswordResetFailed:
            break
            
        default:
            break
        }
    }
    
    func resetValidationLabels() {
        
        // Reset Text
        validationUsernameLabel.text = ""
        validationPasswordLabel.text = ""
        validationConfirmPasswordLabel.text = ""
        
    }
}

extension UIView {
    func shake(vibrate: Bool) {
        if (vibrate == true) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.addAnimation(animation, forKey: "shake")
    }
    
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}
