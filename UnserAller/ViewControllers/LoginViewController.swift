//
//  LoginViewController.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var username: UITextField!;
    @IBOutlet var password: UITextField!;
//    @IBOutlet var loginButtonView: CSAnimationView!
    
    override func viewDidLoad()  {
        super.viewDidLoad();
        
    }
    
    override func didReceiveMemoryWarning()  {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        loginButtonView.backgroundColor = UIColor.clearColor()
//        self.loginButtonView.type = "CSAnimationTypeShake"
//        self.loginButtonView.duration = 0.4
        
        
    }
    
    @IBAction func loginAction(sender: UIButton) {
        self.auth(self.username.text, password: self.password.text)
    }
    
    @IBAction func goBackToLogin(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
//        self.navigationController.popViewControllerAnimated(true)
    }
    
    func loadRootView() {
        
        var root: UINavigationController! = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as UINavigationController
        
        self.presentViewController(root, animated: false, completion: nil);
    }
    
    func auth(email: String, password: String) {
        var userService: UAUser = UAUser();
        if(userService.checkStringsWithString(email) && userService.checkStringsWithString(password)) {
            
            userService.getUserCrederntials(email, password: password,
                success: {
                    userService.saveEmailAndPasswordToKeychain(email, password: password)
                    self.loadRootView();
                },error: {
                    println("Login error")
            })
        } else {
            println("empty login string(s)")
        }
    }
}
