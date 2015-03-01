//
//  SettingsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var viewSwitch: UISegmentedControl!
    
    var views: [AnyObject] = ["", "", ""]
    var settingsObject: Dictionary<String, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        self.registerNibs()
        self.setSegmetedControl()
        
        self.setFirstCell()
        self.getSettings({ () -> Void in
            let settings = self.settingsObject["settings"] as Dictionary<String, AnyObject>
            let address = self.settingsObject["address"] as Dictionary<String, AnyObject>
            (self.views[0] as InformationTableViewCell).setCell(settings, address: address)
        }, failure: { () -> Void in
            
        })
    }
    
    func registerNibs() {
        var InformationTableViewCellNib = UINib(nibName: "InformationTableViewCell", bundle: nil)
        self.mainTable.registerNib(InformationTableViewCellNib, forCellReuseIdentifier: "InformationTableViewCell")
        var PasswordTableViewCellNib = UINib(nibName: "PasswordTableViewCell", bundle: nil)
        self.mainTable.registerNib(PasswordTableViewCellNib, forCellReuseIdentifier: "PasswordTableViewCell")
        var NotificationsTableViewCellNib = UINib(nibName: "NotificationsTableViewCell", bundle: nil)
        self.mainTable.registerNib(NotificationsTableViewCellNib, forCellReuseIdentifier: "NotificationsTableViewCell")
    }
    
    // MARK: - Segmented Controller
    /**
    Set segmented control
    */
    func setSegmetedControl() {
        self.viewSwitch.setDividerImage(UIImage(named: "SegmentedController_bg-1"), forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        self.viewSwitch.setDividerImage(UIImage(named: "SegmentedController_bg-1"), forLeftSegmentState: UIControlState.Selected, rightSegmentState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        self.viewSwitch.setDividerImage(UIImage(named: "SegmentedController_bg-1"), forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        
        // background
        self.viewSwitch.setBackgroundImage(UIImage(named: "SegmentedController_bg"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        self.viewSwitch.setBackgroundImage(UIImage(named: "SegmentedController_bg_grey"), forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        
        // positioning
        // divider = 11px
//        self.viewSwitch.setContentPositionAdjustment(UIOffsetMake(11/2, 0), forSegmentType: UISegmentedControlSegment.Left, barMetrics: UIBarMetrics.Default)
//        self.viewSwitch.setContentPositionAdjustment(UIOffsetMake(-11/2, 0), forSegmentType: UISegmentedControlSegment.Right, barMetrics: UIBarMetrics.Default)
        
    }
    
    func setFirstCell() {
        // set first cell
        var cell = self.mainTable.dequeueReusableCellWithIdentifier("InformationTableViewCell") as InformationTableViewCell
        cell.firstNameInput.delegate = self
        cell.lastNameInput.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // update profile info
        cell.updateProfileInfo.addTarget(self, action: "updateProfileInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        // update address info
        cell.updateAddressInfo.addTarget(self, action: "updatePostalAddressInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        self.views[0] = cell;
    }
    
    @IBAction func changeView(sender: UISegmentedControl) {
        
        if (!(self.views[self.viewSwitch.selectedSegmentIndex] is UITableViewCell)) {
            var cell: UITableViewCell!
            
            if (self.viewSwitch.selectedSegmentIndex == 1) {
                cell = self.mainTable.dequeueReusableCellWithIdentifier("PasswordTableViewCell") as PasswordTableViewCell
                (cell as PasswordTableViewCell).changePasswordButton.addTarget(self, action: "changePassword:", forControlEvents: UIControlEvents.TouchUpInside)
            } else if (self.viewSwitch.selectedSegmentIndex == 2) {
                cell = self.mainTable.dequeueReusableCellWithIdentifier("NotificationsTableViewCell") as NotificationsTableViewCell
                // set up cell
                (cell as NotificationsTableViewCell).setUpCell(self.settingsObject["notifications"] as Dictionary<String, AnyObject>)
                // add action to button
                (cell as NotificationsTableViewCell).updateButton.addTarget(self, action: "updateNotifications:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            self.views[self.viewSwitch.selectedSegmentIndex] = cell
        }
        
        self.mainTable.reloadData()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.views[self.viewSwitch.selectedSegmentIndex] as UITableViewCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(500.0)
    }
    
    
    // MARK: - load
    func getSettings(success: () -> Void, failure: () -> Void) {
        let url: String = "https://\(APIURL)/api/mobile/profile/getsettings"
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { (_, _, JSON, errors) -> Void in
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    // error block
                    failure()
                } else {
                    self.settingsObject = JSON as Dictionary<String, AnyObject>
                    success()
                }
        }
    }
    
    // MARK: button actions
    @IBAction func updateProfileInfo(sender: AnyObject) {
        self.view.endEditing(true)
        let cell = self.views[0] as InformationTableViewCell
        // save
        let url: String = "https://\(APIURL)/api/mobile/profile/saveuserinfo"
        
        let params = ["firstname": cell.firstNameInput.text, "lastname": cell.lastNameInput.text]
        
        Alamofire.request(.POST, url, parameters: params)
            .responseJSON { (_, _, JSON, errors) -> Void in
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                } else {
                    println("saved")
                }
        }
    }
    @IBAction func updatePostalAddressInfo(sender: AnyObject) {
        self.view.endEditing(true)
        let cell = self.views[0] as InformationTableViewCell
        

    }
    
    @IBAction func changePassword(sender: AnyObject) {
        self.view.endEditing(true)
        
        let cell = self.views[1] as PasswordTableViewCell
        
        // save
        let url: String = "https://\(APIURL)/api/v1/user/resetpassword"
        
        Alamofire.request(.POST, url, parameters: ["oldpass": cell.actualPassword.text, "password": cell.newPassword.text])
            .response { (request, response, data, errors) -> Void in
                
                if(errors != nil || response?.statusCode >= 400) {
                    // print error
                    println(errors)
                    cell.errorLabel.text = "error!!!"
                } else {
                    cell.errorLabel.text = ""
                    cell.actualPassword.text = ""
                    cell.newPassword.text = ""
                    cell.repeatNewPassword.text = ""
                    println("changed")
                }
        }
    }
    
    @IBAction func updateNotifications(sender: AnyObject) {
        self.view.endEditing(true)
        
        let cell = self.views[2] as NotificationsTableViewCell
        
        // save
        let url: String = "https://\(APIURL)/api/mobile/profile/updatenotifications"
        
        Alamofire.request(.POST, url, parameters: [
            "commentNotification": (cell.newCommentsSwitch.on) ? 1 : 0,
            "projectInformation": (cell.projectNewsSwitch.on) ? 1 : 0,
            "projectInvitation": (cell.projectInvitesSwitch.on) ? 1 : 0,
            "subscription": (cell.generalNewsSwitch.on) ? 1 : 0
            ])
            .response { (request, response, data, errors) -> Void in
                
                if(errors != nil || response?.statusCode >= 400) {
                    // print error
                    println(errors)
                } else {
                    println("changed")
                }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}
