//
//  SettingsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var viewSwitch: UISegmentedControl!
    
    
    var views: [AnyObject] = ["", "", ""]
    var settingsObject: Dictionary<String, AnyObject>!
    var pickerViewTextField: UITextField!
    var pickerArray: [String: AnyObject]!
    let languages: [String: AnyObject] = ["0": "Deutsch", "1": "English"]
    let notificationIntervals: [String: AnyObject] = ["instant": "instantly", "daily": "daily", "weekly": "weekly", "never": "never"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        self.registerNibs()
        self.setSegmetedControl()
        
        self.setFirstCell()
        
        // uipicker
        self.setupUIPicker()
        
        // set ui picker's array
        self.pickerArray = self.languages
        
        // load settings
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
        // language button
        cell.languageButton.addTarget(self, action: "updateLanguage:", forControlEvents: UIControlEvents.TouchUpInside)
        
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
                // update notification interval
                (cell as NotificationsTableViewCell).notificationIntervalButton.addTarget(self, action: "updateNotificationInterval:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            self.views[self.viewSwitch.selectedSegmentIndex] = cell
        }
        
        
        self.updateUIPickerView(self.viewSwitch.selectedSegmentIndex)
        self.mainTable.reloadData()
    }
    
    func updateUIPickerView(selectedIndex: Int) {
        var selected: String!
        if (selectedIndex == 0) {
            self.pickerArray = self.languages
            let settings = self.settingsObject["settings"] as Dictionary<String, AnyObject>
            if let language = settings["language"]?.objectForKey("value") as? String {
                selected = language
            } else {
                selected = "0"
            }
        } else if (selectedIndex == 2) {
            self.pickerArray = self.notificationIntervals
            let notifications = self.settingsObject["notifications"] as Dictionary<String, AnyObject>
            if let interval = notifications["notificationInterval"]?.objectForKey("value") as? String {
                selected = interval
            } else {
                selected = "instant"
            }
        }
        
        let keys = self.pickerArray.keys.array
        let position = find(keys, selected)?.hashValue

        (self.pickerViewTextField.inputView as UIPickerView).selectRow(position!, inComponent: 0, animated: true)
        // update uipicker
        (self.pickerViewTextField.inputView as UIPickerView).reloadAllComponents()
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
    /**
    Update account information
    
    :param: sender
    */
    @IBAction func updateProfileInfo(sender: AnyObject) {
        self.view.endEditing(true)
        let cell = self.views[0] as InformationTableViewCell
        // save
        let url: String = "https://\(APIURL)/api/mobile/profile/saveuserinfo"
        
        let params = ["firstname": cell.firstNameInput.text, "lastname": cell.lastNameInput.text, "language": cell.language]
        
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
    
    /**
    Update postal address on button press
    
    :param: sender
    */
    @IBAction func updatePostalAddressInfo(sender: AnyObject) {
        self.view.endEditing(true)
        let url = "https://\(APIURL)/api/mobile/profile/saveuserpostalinfo"
        let cell = self.views[0] as InformationTableViewCell
        
        Alamofire.request(.POST, url, parameters: [
            "firstname":    cell.firstNameAddressInput.text,
            "lastname":     cell.lastNameAddressInput.text,
            "street":       cell.streetAddressInput.text,
            "city":         cell.cityAddressInput.text,
            "zipCode":      cell.zipAddressInput.text,
            "address":      cell.addressAddressInput.text,
            "gender":       "\(cell.gender.selectedSegmentIndex)"
            ])
            .response{ (request, response, data, errors) -> Void in
                
                if(errors != nil || response?.statusCode >= 400) {
                    // print error
                    println(errors)
                } else {
                    println("changed")
                }
        }
    }
    
    /**
     Change account password

     :param: sender 
     */
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
    
    /**
    Update notifications
    
    :param: sender
    */
    @IBAction func updateNotifications(sender: AnyObject) {
        self.view.endEditing(true)
        
        let cell = self.views[2] as NotificationsTableViewCell
        
        // save
        let url: String = "https://\(APIURL)/api/mobile/profile/updatenotifications"
        
        Alamofire.request(.POST, url, parameters: [
            "commentNotification":  (cell.newCommentsSwitch.on) ? 1 : 0,
            "projectInformation":   (cell.projectNewsSwitch.on) ? 1 : 0,
            "projectInvitation":    (cell.projectInvitesSwitch.on) ? 1 : 0,
            "subscription":         (cell.generalNewsSwitch.on) ? 1 : 0,
            "notificationInterval": cell.notificationInterval
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
    
    // MARK: - UIPICKER
    /**
    set up ui picker view
    */
    func setupUIPicker() {
        // set the frame to zero
        self.pickerViewTextField = UITextField(frame: CGRectZero)
        self.view.addSubview(self.pickerViewTextField)
        
        var pickerView: UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 0, 0))
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // set change the inputView (default is keyboard) to UIPickerView
        self.pickerViewTextField.inputView = pickerView
        
        self.pickerViewTextField.inputAccessoryView = self.createToolbarForUIPicker();
    }
    
    /**
    Create toolbar
    
    :returns: uitoolbar
    */
    func createToolbarForUIPicker() -> UIToolbar {
        // create a toolbar with Cancel & Done button
        var toolBar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        toolBar.barStyle = UIBarStyle.Default
        
        var doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneTouched:")
        var cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelTouched:")
        
        // the middle button is to make the Done button align to right
        toolBar.setItems([cancelButton, UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil), doneButton], animated: false)
        
        return toolBar
    }
    
    func updateLanguage(sender: AnyObject) {
        self.pickerViewTextField.becomeFirstResponder()
    }
    func updateNotificationInterval(sender: AnyObject) {
        self.pickerViewTextField.becomeFirstResponder()
    }
    
    func cancelTouched(sender: AnyObject) {
        // hide the picker view
        self.pickerViewTextField.resignFirstResponder()
    }
    
    func doneTouched(sender: AnyObject) {
    
        // hide the picker view
        self.pickerViewTextField.resignFirstResponder()
    
        // perform some action
        let keys = self.pickerArray.keys.array
        let key = keys[(self.pickerViewTextField.inputView as UIPickerView).selectedRowInComponent(0)]
        
        if (self.viewSwitch.selectedSegmentIndex == 0) {
            (self.views[0] as InformationTableViewCell).language = key
        } else if (self.viewSwitch.selectedSegmentIndex == 2) {
            (self.views[0] as NotificationsTableViewCell).notificationInterval = key
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let keys = self.pickerArray.keys.array
        let key = keys[row] as String
        return self.pickerArray[key] as String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // selected
    }
}
