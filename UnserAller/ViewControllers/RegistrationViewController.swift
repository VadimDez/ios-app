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
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, countElements(self))) != nil
    }
}

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func registerAction(sender: AnyObject) {
        self.createAccount()
    }
    
    /**
    Create account
    */
    func createAccount() {
        if (self.validateUserCredentials()) {
            self.checkAvailableEmail({ (available) -> Void in
                if (available) {
                    self.registerNewUser({ () -> Void in
                        
                        println("registered")
                        let user = UAUser()
                        
                        // save email and password
                        user.saveEmailAndPasswordToKeychain(self.email.text, password: self.password.text)
                        
                        // present login view
                        var login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as LoginViewController
                        self.presentViewController(login, animated: false, completion: nil)
                        
                        
                    }, failure: { () -> Void in
                        
                        println("not registered")
                    })
                } else {
                    println("not valid")
                }
                
            }, failure: { () -> Void in
                
                println("not valid")
                
            })
            
        } else {
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
        let url: String = "https://\(APIURL)/api/mobile/auth/checkemail"
        
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
        let url: String = "https://\(APIURL)/api/mobile/auth/register"
        
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
}
