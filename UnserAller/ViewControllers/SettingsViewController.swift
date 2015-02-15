//
//  SettingsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /**
    Logout button
    
    :param: sender
    */
    @IBAction func logoutAction(sender: AnyObject) {
        var user: UAUser = UAUser()

        // logout
        user.logout({ () -> Void in
            // show initial
            self.presentInitialViewController()
        }, failure: { () -> Void in

        })
    }
    
    /**
    Show initial view controller
    */
    func presentInitialViewController() {
        var initViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Initial") as InitViewController
        
        var navigationController = UINavigationController(rootViewController: initViewController)
        navigationController.navigationBar.hidden = true
        
        self.presentViewController(navigationController, animated: false, completion: nil)
    }
}
