//
//  LoginViewController.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation
import UIKit
import DrawerController

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
//    @IBOutlet var loginButtonView: CSAnimationView!
    @IBOutlet weak var loginButton: RNLoadingButton!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        
        self.loginButton.hideTextWhenLoading = true
        self.loginButton.setActivityIndicatorAlignment(RNLoadingButtonAlignmentCenter)
        self.loginButton.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.White, forState: UIControlState.Disabled)
    }
    
    override func didReceiveMemoryWarning()  {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        loginButtonView.backgroundColor = UIColor.clearColor()
//        self.loginButtonView.type = "CSAnimationTypeShake"
//        self.loginButtonView.duration = 0.4
        
        self.configureElements()
        var singleTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(singleTapRecognizer)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent//UIStatusBarStyle.Black
    }
    
    func configureElements() {
//        self.containerView.layer.cornerRadius = 7
//        self.containerView.layer.borderWidth = 0.5
//        self.containerView.layer.borderColor = UIColor.whiteColor().CGColor
        
//        self.loginButton.layer.cornerRadius = 4
    }
    
    @IBAction func loginAction(sender: UIButton) {
        self.auth(self.username.text, password: self.password.text)
    }
    
    @IBAction func goBackToLogin(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadRootView() {
        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as! UINavigationController
        let leftSideNavController = self.storyboard?.instantiateViewControllerWithIdentifier("menuNavi") as! UINavigationController
        leftSideNavController.navigationBar.hidden = true
        
        var drawerController: DrawerController = DrawerController(centerViewController: navigationController, leftDrawerViewController: leftSideNavController, rightDrawerViewController: nil)
        drawerController.showsShadows = true
        
        drawerController.restorationIdentifier = "Drawer"
        drawerController.maximumLeftDrawerWidth = 240.0
        drawerController.openDrawerGestureModeMask = OpenDrawerGestureMode.BezelPanningCenterView
        drawerController.closeDrawerGestureModeMask = .All
        drawerController.drawerVisualStateBlock = DrawerVisualState.parallaxVisualStateBlock(CGFloat(1.0))
        
        self.presentViewController(drawerController, animated: false, completion: nil)
    }
    
    func auth(email: String, password: String) {
        var userService: UAUser = UAUser()
        
        self.loginButton.enabled = false
        self.loginButton.loading = true
        
        if(userService.checkStringsWithString(email) && userService.checkStringsWithString(password)) {
            
            userService.getUserCrederntials(email, password: password,
                success: {
                    userService.saveEmailAndPasswordToKeychain(email, password: password)
                    self.loadRootView();
                    
                    self.loginButton.enabled = true
                    self.loginButton.loading = false
                },error: {
                    println("Login error")
                    
                    self.loginButton.enabled = true
                    self.loginButton.loading = false
            })
        } else {
            println("empty login string(s)")
            
            self.loginButton.enabled = true
            self.loginButton.loading = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
