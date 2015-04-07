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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var username: UITextField!;
    @IBOutlet var password: UITextField!;
//    @IBOutlet var loginButtonView: CSAnimationView!
    @IBOutlet weak var loginButton: UIButton!
    
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
        
        self.configureElements()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    func configureElements() {
        self.containerView.layer.cornerRadius = 7
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.loginButton.layer.cornerRadius = 4
    }
    
    @IBAction func loginAction(sender: UIButton) {
        self.auth(self.username.text, password: self.password.text)
    }
    
    @IBAction func goBackToLogin(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadRootView() {
        // old
//        var root: UINavigationController! = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as UINavigationController
//        
//        self.presentViewController(root, animated: false, completion: nil);
        
        // new
        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as UINavigationController
        let leftSideNavController = self.storyboard?.instantiateViewControllerWithIdentifier("menuNavi") as UINavigationController
        leftSideNavController.navigationBar.hidden = true
        
        var drawerController: DrawerController = DrawerController(centerViewController: navigationController, leftDrawerViewController: leftSideNavController, rightDrawerViewController: nil)
        drawerController.showsShadows = true
        
        drawerController.restorationIdentifier = "Drawer"
        drawerController.maximumLeftDrawerWidth = 240.0
        drawerController.openDrawerGestureModeMask = .All
        drawerController.closeDrawerGestureModeMask = .All
        drawerController.drawerVisualStateBlock = DrawerVisualState.parallaxVisualStateBlock(CGFloat(1.0))
        
        self.presentViewController(drawerController, animated: false, completion: nil)
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
