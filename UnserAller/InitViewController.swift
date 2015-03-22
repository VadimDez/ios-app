//
//  ViewController.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
        let (dictionary, error) = Locksmith.loadDataForUserAccount("UnserAllerUser", inService: "UnserAller")
        
        // if an error
        if let error = error {
            println("Keychain Error: \(error)")
    
            super.viewWillAppear(animated)
        }
        
        if let dictionary = dictionary {
            if (dictionary["UserAuthEmailToken"] != nil && dictionary["UserAuthPasswordToken"] != nil) {
                let userService: UAUser = UAUser()

                userService.getUserCrederntials(dictionary["UserAuthEmailToken"] as String, password: dictionary["UserAuthPasswordToken"] as String, success: { () -> Void in

                    let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as UINavigationController
                    let leftSideNavController = self.storyboard?.instantiateViewControllerWithIdentifier("menuNavi") as UINavigationController
                    // hide navbar
                    leftSideNavController.navigationBar.hidden = true
                    
                    var drawerController: DrawerController = DrawerController(centerViewController: navigationController, leftDrawerViewController: leftSideNavController, rightDrawerViewController: nil)
                    drawerController.showsShadows = true
                    
                    drawerController.restorationIdentifier = "Drawer"
                    drawerController.maximumLeftDrawerWidth = 240.0
                    drawerController.openDrawerGestureModeMask = .All
                    drawerController.closeDrawerGestureModeMask = .All
                    drawerController.drawerVisualStateBlock = DrawerVisualState.parallaxVisualStateBlock(CGFloat(1.0))

                    self.presentViewController(drawerController, animated: false, completion: nil)

                }, error: { () -> Void in
                    
                })
            } else {
                super.viewWillAppear(animated)
            }
        }
    }
}

