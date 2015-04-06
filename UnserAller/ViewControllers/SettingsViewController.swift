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
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var views: [AnyObject] = ["", "", ""]
    var settingsDictionary: Dictionary<String, AnyObject>!
    var pickerViewTextField: UITextField!
    var pickerArray: [String: AnyObject]!
    var user: UAUser = UAUser()
    let languages: [String: AnyObject] = ["0": "Deutsch", "1": "English"]
    let notificationIntervals: [String: AnyObject] = ["instant": "instantly", "daily": "daily", "weekly": "weekly", "never": "never"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        self.registerNibs()
        self.setSegmetedControl()
        self.navigationBar()
        self.setFirstCell()
        
        // uipicker
        self.setupUIPicker()
        
        // set ui picker's array
        self.pickerArray = self.languages
        
        // load settings
        self.user.getSettings({ (settings) -> Void in

            self.settingsDictionary = settings
            let _settings = settings["settings"] as Dictionary<String, AnyObject>
            let _address = settings["address"] as Dictionary<String, AnyObject>
            
            self.loadProfileImage()
            
            // set up
            (self.views[0] as InformationTableViewCell).setCell(_settings, address: _address)
            
        }, failure: { () -> Void in
            
        })
    }
    
    func navigationBar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.translucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clearColor()
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
    
    func loadProfileImage() {
        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "https://\(APIURL)/media/profileimage/4/80/80")!)
        self.profileImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            
            if let weakSelf = self {
                weakSelf.profileImage.image = image
                
                // add blur
                var blur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
                
                var blurView = UIVisualEffectView(effect: blur)
                
                blurView.frame = weakSelf.backgroundImage.bounds
                // set image
                weakSelf.backgroundImage.image = image
                // add blur
                weakSelf.backgroundImage.addSubview(blurView)
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
        }
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
                (cell as NotificationsTableViewCell).setUpCell(self.settingsDictionary["notifications"] as Dictionary<String, AnyObject>)
                
                // add action to button
                (cell as NotificationsTableViewCell).updateButton.addTarget(self, action: "updateNotifications:", forControlEvents: UIControlEvents.TouchUpInside)
                
                // update notification interval
                (cell as NotificationsTableViewCell).notificationIntervalButton.addTarget(self, action: "updateNotificationInterval:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            self.views[self.viewSwitch.selectedSegmentIndex] = cell
        }
        
        
        if (self.viewSwitch.selectedSegmentIndex == 0 || self.viewSwitch.selectedSegmentIndex == 2) {
            self.updateUIPickerView(self.viewSwitch.selectedSegmentIndex)
        }
        self.mainTable.reloadData()
    }
    
    /**
    Update uipicker view

    :param: selectedIndex int
    */
    func updateUIPickerView(selectedIndex: Int) {
        var selected: String!
        
        if (selectedIndex == 0) {
            self.pickerArray = self.languages
            
            // get selected "0" or "1", etc
            selected = (self.views[0] as InformationTableViewCell).language
            
        } else if (selectedIndex == 2) {
            self.pickerArray = self.notificationIntervals
            
            // get notification interval
            selected = (self.views[2] as NotificationsTableViewCell).notificationInterval
        }
        
        let keys = self.pickerArray.keys.array
        
        let position = find(keys, selected)?.hashValue
        
        // update uipicker
        (self.pickerViewTextField.inputView as UIPickerView).reloadAllComponents()
        
        // select row
        (self.pickerViewTextField.inputView as UIPickerView).selectRow(position!, inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    /**
    Logout button
    
    :param: sender
    */
    @IBAction func logoutAction(sender: AnyObject) {
        // logout
        self.user.logout({ () -> Void in
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
    
    // MARK: table view
    
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
        if (self.viewSwitch.selectedSegmentIndex == 0) {
            return CGFloat(500.0)
        } else if (self.viewSwitch.selectedSegmentIndex == 1) {
            return CGFloat(200.0)
        }
        
        return CGFloat(230.0)
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
        self.user.updateInfo(cell.firstNameInput.text, lastName: cell.lastNameInput.text, language: cell.language, success: { () -> Void in
            // success
        }) { () -> Void in
            // failure
        }
    }
    
    /**
    Update postal address on button press
    
    :param: sender
    */
    @IBAction func updatePostalAddressInfo(sender: AnyObject) {
        self.view.endEditing(true)
        let cell = self.views[0] as InformationTableViewCell
        
        let gender = "\(cell.gender.selectedSegmentIndex)"
        
        self.user.updateAddress(cell.firstNameAddressInput.text, lastName: cell.lastNameAddressInput.text, street: cell.streetAddressInput.text, city: cell.cityAddressInput.text, zipCode: cell.zipAddressInput.text, address: cell.addressAddressInput.text, gender: gender, success: { () -> Void in
            // success
        }) { () -> Void in
            // failure
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
        self.user.changePassword(cell.actualPassword.text, newPassword: cell.newPassword.text, success: { () -> Void in
            // success
            cell.clear()
        }) { () -> Void in
            // failure
            cell.errorLabel.text = "error!!!"
        }
    }
    
    /**
    Update notifications
    
    :param: sender
    */
    @IBAction func updateNotifications(sender: AnyObject) {
        self.view.endEditing(true)
        
        let cell = self.views[2] as NotificationsTableViewCell
        
        let commentNotification =  (cell.newCommentsSwitch.on) ? 1 : 0;
        let projectInformation = (cell.projectNewsSwitch.on) ? 1 : 0;
        let projectInvitation =    (cell.projectInvitesSwitch.on) ? 1 : 0;
        let subscription =    (cell.generalNewsSwitch.on) ? 1 : 0;
        
        // update
        self.user.updateNotifications(commentNotification, projectInformation: projectInformation, projectInvitation: projectInvitation, subscription: subscription, notificationInterval: cell.notificationInterval, success: { () -> Void in
            // success
        }) { () -> Void in
            // failure
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
            (self.views[0] as InformationTableViewCell).setLanguage(key)
        } else if (self.viewSwitch.selectedSegmentIndex == 2) {
            (self.views[2] as NotificationsTableViewCell).setInterval(key)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let keys    = self.pickerArray.keys.array
        let key     = keys[row] as String
        return self.pickerArray[key] as String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // selected
    }
}
