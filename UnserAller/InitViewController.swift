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
        
        if(Keychain.load("UserAuthUserToken") != nil && Keychain.load("UserAuthPasswordToken") != nil) {
            
            let dataEmail: NSData = Keychain.load("UserAuthUserToken")!
            let dataPassword: NSData = Keychain.load("UserAuthPasswordToken")!
            let UserService: User = User()
            
            UserService.getUserCrederntials(UserService.decode(dataEmail), password: UserService.decode(dataPassword), success: { () -> Void in
                
                var root: UINavigationController! = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as UINavigationController
                
                self.presentViewController(root, animated: false, completion: nil);
            }, error: { () -> Void in
                
            })
        } else {
            super.viewWillAppear(animated)
        }
    }
}

