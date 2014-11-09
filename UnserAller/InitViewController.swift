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

        // delete email and pass from keychain
//        Locksmith.deleteData(forKey: "UnserAllerAuthToken", inService: "UnserAller", forUserAccount: "UnserAllerUser")
        
        let (dictionary, error) = Locksmith.loadData(forKey: "UnserAllerAuthToken", inService: "UnserAller", forUserAccount: "UnserAllerUser")
        
        
        // if an error
        if let error = error {
            println("Keychain Error: \(error)")
    
            super.viewWillAppear(animated)
        }
        
        if let dictionary = dictionary {
            if (dictionary["UserAuthEmailToken"] != nil && dictionary["UserAuthPasswordToken"] != nil) {
                let userService: UAUser = UAUser()
                
                userService.getUserCrederntials(dictionary["UserAuthEmailToken"] as String, password: dictionary["UserAuthPasswordToken"] as String, success: { () -> Void in
                    var root: UINavigationController! = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as UINavigationController
                    
                    self.presentViewController(root, animated: false, completion: nil)
                }, error: { () -> Void in
                    
                })
            } else {
                super.viewWillAppear(animated)
            }
        }
    }
}

