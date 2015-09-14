//
//  RegistrationViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/02/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension String {
    func isEmail() -> Bool {
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
    }
}

class RegistrationViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registerButton: RNLoadingButton!
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    weak var activeTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureElements()
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.scrollView.delegate = self
        
        
        var singleTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(singleTapRecognizer)
        
        self.resetInsets()
        self.registerForKeyboardNotifications()
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureElements() {
//        self.containerView.layer.cornerRadius = 7
//        self.containerView.layer.borderColor = UIColor.whiteColor().CGColor
//        self.containerView.layer.borderWidth = 0.5
//        self.registerButton.layer.cornerRadius = 4
        
        self.registerButton.hideTextWhenLoading = true
        self.registerButton.setActivityIndicatorAlignment(RNLoadingButtonAlignmentCenter)
        self.registerButton.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.White, forState: UIControlState.Disabled)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent//UIStatusBarStyle.Black
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        self.createAccount()
    }
    
    /**
    Create account
    */
    func createAccount() {
        self.registerButton.enabled = false
        self.registerButton.loading = true
        
        if (self.validateUserCredentials()) {
            self.checkAvailableEmail({ (available) -> Void in
                if (available) {
                    self.registerNewUser({ () -> Void in
                        
                        println("registered")
                        let user = UAUser()
                        
                        // save email and password
                        user.saveEmailAndPasswordToKeychain(self.email.text, password: self.password.text)
                        
                        // present login view
                        var login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
                        self.presentViewController(login, animated: false, completion: nil)
                        
                        self.registerButton.enabled = true
                        self.registerButton.loading = false
                        
                    }, failure: { () -> Void in
                        
                        println("not registered")
                        self.registerButton.enabled = true
                        self.registerButton.loading = false
                    })
                } else {
                    println("not valid")
                    self.registerButton.enabled = true
                    self.registerButton.loading = false
                }
                
            }, failure: { () -> Void in
                
                println("not valid")
                self.registerButton.enabled = true
                self.registerButton.loading = false
                
            })
            
        } else {
            self.registerButton.enabled = true
            self.registerButton.loading = false
            println("not valid")
        }
    }
    
    func validateUserCredentials() -> Bool {
        if (!self.email.text.isEmail() || self.firstName.text.isEmpty || self.lastName.text.isEmpty || self.password.text.isEmpty) {
            return false
        }
        
        return true
    }
    
    
    /**
    Check if email is available
    
    :param: success callback
    :param: failure callback
    */
    func checkAvailableEmail(success: (available: Bool) -> Void, failure: () -> Void) {
        // build URL
        let url: String = "\(APIURL)/api/mobile/auth/checkemail"
        
        // get entries
        Alamofire.request(.GET, url, parameters: ["email": self.email.text])
            .responseJSON { (_, _, JSON, error) in

                if(error != nil) {
                    // print error
                    println(error)
                    // error block
                    failure()
                } else {
                    var isAvailable = false
                    if let answer = JSON?.objectForKey("available") as? String {
                        if (answer == "yes") {
                            isAvailable = true
                        }
                    }
                    success(available: isAvailable)
                }
        }
    }
    
    /**
    Register new user
    
    :param: success callback
    */
    func registerNewUser(success: () -> Void, failure: () -> Void) {
        // build URL
        let url: String = "\(APIURL)/api/mobile/auth/register"
        
        // get entries
        Alamofire.request(.POST, url, parameters: ["email": self.email.text, "password": self.password.text, "firstname": self.firstName.text, "lastname": self.lastName.text])
            .responseJSON { (_, _, JSON, error) in
                
                if(error != nil) {
                    // print error
                    println(error)
                    // error block
                    failure()
                } else {
                    var isRegistered = false

                    if let answer = JSON?.objectForKey("registered") as? String {
                        isRegistered = (answer == "true") ? true : false
                    }
                    
                    if (isRegistered) {
                        success()
                    } else {
                        failure()
                    }
                }
        }
    }
    
    
    
    
    //MARK: - Keyboard Management Methods
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        
        if let userInfo: NSDictionary = sender.userInfo {
            let value: NSValue = userInfo.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
            let keyboardSize: CGSize = value.CGRectValue().size
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if (self.activeTextField != nil) {
                let activeTextFieldRect: CGRect = CGRect(x: self.activeTextField.frame.origin.x, y: self.activeTextField.frame.origin.y + 50.0, width: activeTextField.frame.width, height: self.activeTextField.frame.height)

                if (!CGRectContainsPoint(aRect, activeTextFieldRect.origin)) {
                    let pointToScroll = CGPointMake(0, activeTextFieldRect.origin.y - aRect.size.height + self.activeTextField.frame.size.height)
                    self.scrollView.setContentOffset(pointToScroll, animated: true)
                }
            }
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        self.resetInsets()
    }
    
    func resetInsets() -> Void {
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
