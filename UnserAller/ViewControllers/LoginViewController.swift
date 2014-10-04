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
        var userService = User();
        
        if(userService.checkStringsWithString(username.text) && userService.checkStringsWithString(password.text)) {
            println("right");
            self.loadRootView();
        }
    }
    
    @IBAction func goBackToLogin(sender: AnyObject) {
        self.navigationController.popViewControllerAnimated(true)
    }
    
    func loadRootView() {
        var root: UIViewController! = self.storyboard.instantiateViewControllerWithIdentifier("initVC") as ECSlidingViewController;
        
        self.presentViewController(root, animated: false, completion: nil);
    }
}
