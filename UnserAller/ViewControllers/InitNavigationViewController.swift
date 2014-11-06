//
//  InitNavigationViewController.swift
//  UnserAller
//
//  Created by Vadym on 04/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class InitNavigationViewController: ENSideMenuNavigationController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnSwipe = true
        
        let menu: MenuTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Menu") as MenuTableViewController
        
        sideMenu = ENSideMenu(sourceView: self.view, menuTableViewController: menu, menuPosition: .Left)
        
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 250.0 // optional, default is 160
        
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        println("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        println("sideMenuWillClose")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
