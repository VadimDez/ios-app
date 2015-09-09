//
//  SettingsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate/*, UIScrollViewDelegate*/ {

    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    // show views
    @IBOutlet weak var informationViewBtn: UIButton!
    @IBOutlet weak var addressViewBtn: UIButton!
    @IBOutlet weak var passwordViewBtn: UIButton!
    @IBOutlet weak var notificationsViewBtn: UIButton!
    
    //
    weak var activeTextField: UITextField!
    ///
    
    var selectedViewIndex: Int = 0
    var views: [AnyObject] = ["", "", "", ""]
    var settingsDictionary: Dictionary<String, AnyObject>!
    var pickerViewTextField: UITextField!
    var pickerArray: [String: AnyObject]!
    var user: UAUser = UAUser()
    let languages: [String: AnyObject] = ["0": "Deutsch", "1": "English"]
    let notificationIntervals: [String: AnyObject] = ["instant": "instantly", "daily": "daily", "weekly": "weekly", "never": "never"]
    let genders: [String: AnyObject] = ["0": "Female", "1": "Male"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
        
        // offset
        //        self.mainTable.frame.origin.x = -32.0
//        self.view.frame.origin.y = -100.0
//        self.view.bounds.origin.y = 24.0
        
        // profile image
        self.adjustProfileImage()
        
        var singleTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(singleTapRecognizer)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // disable "over" scroll
//        self.mainTable.bounces = false
        
        self.registerNibs()
        self.navigationBar()
        self.setInformationCell()
        
        
        // uipicker
        self.setupUIPicker()
        
        // set ui picker's array
        self.pickerArray = self.languages

        // load settings
        self.user.getSettings({ (settings) -> Void in

            self.settingsDictionary = settings
            let _settings = settings["settings"] as! Dictionary<String, AnyObject>
            
            self.loadProfileImage()
            
            // set up
            (self.views[0] as! InformationTableViewCell).setCell(_settings)
            
        }, failure: { () -> Void in
            
        })
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func navigationBar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.translucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clearColor()
    }
    
    func adjustProfileImage() {
        var imageLayer:CALayer = self.profileImage.layer
        imageLayer.cornerRadius = self.profileImage.frame.width / 2
        imageLayer.masksToBounds = true
    }
    
    func registerNibs() {
        let InformationTableViewCellNib = UINib(nibName: "InformationTableViewCell", bundle: nil)
        self.mainTable.registerNib(InformationTableViewCellNib, forCellReuseIdentifier: "InformationTableViewCell")
        
        let addressTableViewCellNib = UINib(nibName: "AddressTableViewCell", bundle: nil)
        self.mainTable.registerNib(addressTableViewCellNib, forCellReuseIdentifier: "AddressTableViewCell")
        
        let PasswordTableViewCellNib = UINib(nibName: "PasswordTableViewCell", bundle: nil)
        self.mainTable.registerNib(PasswordTableViewCellNib, forCellReuseIdentifier: "PasswordTableViewCell")
        
        let NotificationsTableViewCellNib = UINib(nibName: "NotificationsTableViewCell", bundle: nil)
        self.mainTable.registerNib(NotificationsTableViewCellNib, forCellReuseIdentifier: "NotificationsTableViewCell")
    }
    
    
    func loadProfileImage() {
        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "\(APIURL)/media/profileimage/4/80/80")!)
        self.profileImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            
            if let weakSelf = self {
                weakSelf.profileImage.image = image
                
                // add blur
                var blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                
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
    
    // set first cell
    func setInformationCell() {
        self.views[0] = self.getInformationCell();
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
            selected = (self.views[0] as! InformationTableViewCell).language
            
        } else if (selectedIndex == 1) {
            self.pickerArray = self.genders

            selected = (self.views[1] as! AddressTableViewCell).gender
        } else if (selectedIndex == 3) {
            self.pickerArray = self.notificationIntervals
            
            // get notification interval
            selected = (self.views[3] as! NotificationsTableViewCell).notificationInterval
        }
        
        let keys = self.pickerArray.keys.array

        let position = find(keys, selected)?.hashValue ?? 0
        
        // update uipicker
        (self.pickerViewTextField.inputView as! UIPickerView).reloadAllComponents()
        
        // select row
        (self.pickerViewTextField.inputView as! UIPickerView).selectRow(position, inComponent: 0, animated: true)
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
        var initViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AuthVC") as! InitViewController
        
        var navigationController = UINavigationController(rootViewController: initViewController)
        navigationController.navigationBar.hidden = true
        
        self.presentViewController(navigationController, animated: false, completion: nil)
    }
    
    // MARK: table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.views[self.selectedViewIndex] as! UITableViewCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.selectedViewIndex == 0) {
            return CGFloat(237.0)
        }
        
        if (self.selectedViewIndex == 1) {
            return CGFloat(385.0)
        }
        
        if (self.selectedViewIndex == 2) {
            return CGFloat(193.0)
        }
        
        return CGFloat(288.0)
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        var cell: UITableViewCell
//        
////        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
////            // Load resources for iOS 6.1 or earlier
////            cell = (UITableViewCell *) textField.superview.superview;
////            
////        } else {
//            // Load resources for iOS 7 or later
//            cell = textField.superview!.superview as! UITableViewCell;
//            // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
////        }
//        
//        self.mainTable.scrollToRowAtIndexPath(self.mainTable.indexPathForCell(cell)!, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
//    }
    
    // MARK: button actions
    /**
    Update account information
    
    :param: sender
    */
    @IBAction func updateProfileInfo(sender: AnyObject) {
        println(sender)
        self.view.endEditing(true)
        let cell = self.views[0] as! InformationTableViewCell
        
        cell.updateProfileInfo.loading = true
        // save
        self.user.updateInfo(cell.firstNameInput.text, lastName: cell.lastNameInput.text, language: cell.language, success: { () -> Void in
            // success
            cell.updateProfileInfo.loading = false
        }) { () -> Void in
            // failure
            cell.updateProfileInfo.loading = false
        }
    }
    
    /**
    Update postal address on button press
    
    :param: sender
    */
    @IBAction func updatePostalAddressInfo(sender: AnyObject) {
        self.view.endEditing(true)
        let cell = self.views[1] as! AddressTableViewCell
        
        cell.updateAddressInfo.loading = true

        self.user.updateAddress(cell.firstNameAddressInput.text,
            lastName: cell.lastNameAddressInput.text,
            street: cell.streetAddressInput.text,
            city: cell.cityAddressInput.text,
            zipCode: cell.zipAddressInput.text,
            address: cell.addressAddressInput.text,
            gender: cell.gender,
            success: { () -> Void in
            // success
                cell.updateAddressInfo.loading = false
        }) { () -> Void in
            // failure
            cell.updateAddressInfo.loading = false
        }
    }
    
    /**
     Change account password

     :param: sender 
     */
    @IBAction func changePassword(sender: AnyObject) {
        self.view.endEditing(true)
        
        let cell = self.views[1] as! PasswordTableViewCell
        
        cell.changePasswordButton.loading = true
        
        // save
        self.user.changePassword(cell.actualPassword.text, newPassword: cell.newPassword.text, success: { () -> Void in
            // success
            cell.clear()
            cell.changePasswordButton.loading = false
        }) { () -> Void in
            // failure
            cell.errorLabel.text = "error!!!"
            cell.changePasswordButton.loading = false
        }
    }
    
    /**
    Update notifications
    
    :param: sender
    */
    @IBAction func updateNotifications(sender: AnyObject) {
        self.view.endEditing(true)
        
        let cell = self.views[2] as! NotificationsTableViewCell
        
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    
    
    
    // MARK: - show views
    @IBAction func showInformationView(sender: AnyObject) {
        self.showSettingsView(sender.tag)
    }
    
    @IBAction func showAddressView(sender: AnyObject) {
        self.showSettingsView(sender.tag)
    }
    
    @IBAction func showPasswordView(sender: AnyObject) {
        self.showSettingsView(sender.tag)
    }
    
    @IBAction func showNotificationView(sender: AnyObject) {
        self.showSettingsView(sender.tag)
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
    func updateGender(sender: AnyObject) {
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
        let key = keys[(self.pickerViewTextField.inputView as! UIPickerView).selectedRowInComponent(0)]
        
        if (self.selectedViewIndex == 0) {
            (self.views[0] as! InformationTableViewCell).updateLanguage(key)
        } else if (self.selectedViewIndex == 1) {
            (self.views[1] as! AddressTableViewCell).updateGender(key)
        } else if (self.selectedViewIndex == 3) {
            (self.views[2] as! NotificationsTableViewCell).setInterval(key)
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
        return self.pickerArray[key] as! String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // selected
    }
    
    // MARK: - other functions
    func showSettingsView(buttonIndex: Int) {
        // update selected view index
        self.selectedViewIndex = buttonIndex
        
        if (!(self.views[buttonIndex] is UITableViewCell)) {
            var cell: UITableViewCell!
            
            if (buttonIndex == 1) { // address
                cell = self.getAddressCell()
            } else if (buttonIndex == 2) { // password
                cell = self.getPasswordCell()
            } else if (buttonIndex == 3) { // notifications
                cell = self.getNotificationCell()
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            self.views[buttonIndex] = cell
        }
        
        
        if (buttonIndex == 0 || buttonIndex == 1 || buttonIndex == 3) {
            self.updateUIPickerView(buttonIndex)
        }
        self.mainTable.reloadData()
    }
    
    func getInformationCell() -> InformationTableViewCell {
        var cell = self.mainTable.dequeueReusableCellWithIdentifier("InformationTableViewCell") as! InformationTableViewCell
        
        cell.firstNameInput.delegate = self
        cell.lastNameInput.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // update profile info
        cell.updateProfileInfo.addTarget(self, action: "updateProfileInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // language button
        cell.languageButton.addTarget(self, action: "updateLanguage:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func getAddressCell() -> AddressTableViewCell {
        var cell = self.mainTable.dequeueReusableCellWithIdentifier("AddressTableViewCell") as! AddressTableViewCell
        
        let _address = self.settingsDictionary["address"] as! Dictionary<String, AnyObject>
        cell.setCell(_address)
        
        // update address info
        cell.updateAddressInfo.addTarget(self, action: "updatePostalAddressInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // gender button
        cell.genderButton.addTarget(self, action: "updateGender:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // delegates
        cell.firstNameAddressInput.delegate = self
        cell.lastNameAddressInput.delegate = self
        cell.addressAddressInput.delegate = self
        cell.streetAddressInput.delegate = self
        cell.zipAddressInput.delegate = self
        cell.cityAddressInput.delegate = self
        
        return cell
    }
    func getPasswordCell() -> PasswordTableViewCell {
        var cell = self.mainTable.dequeueReusableCellWithIdentifier("PasswordTableViewCell") as! PasswordTableViewCell
        
        cell.changePasswordButton.addTarget(self, action: "changePassword:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // delegates
        cell.actualPassword.delegate = self
        cell.newPassword.delegate = self
        cell.repeatNewPassword.delegate = self
        
        return cell
    }
    
    func getNotificationCell() -> NotificationsTableViewCell {
        var cell = self.mainTable.dequeueReusableCellWithIdentifier("NotificationsTableViewCell") as! NotificationsTableViewCell
        
        // set up cell
        cell.setUpCell(self.settingsDictionary["notifications"] as! Dictionary<String, AnyObject>)
        
        // add action to button
        cell.updateButton.addTarget(self, action: "updateNotifications:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // update notification interval
        cell.notificationIntervalButton.addTarget(self, action: "updateNotificationInterval:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    //MARK: - Keyboard Management Methods
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        if let userInfo: NSDictionary = sender.userInfo {
            let value: NSValue = userInfo.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
            let keyboardSize: CGSize = value.CGRectValue().size
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
    //        scrollView.contentInset = contentInsets
    //        scrollView.scrollIndicatorInsets = contentInsets
            
                
            self.mainTable.contentInset = contentInsets
            self.mainTable.scrollIndicatorInsets = contentInsets
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if (activeTextField != nil) {
                let activeTextFieldRect: CGRect = CGRect(x: activeTextField.frame.origin.x, y: activeTextField.frame.origin.y + 300, width: activeTextField.frame.width, height: activeTextField.frame.height)
                
    //            if let activeTextFieldOrigin: CGPoint = activeTextFieldRect.origin {
                    if (!CGRectContainsPoint(aRect, activeTextFieldRect.origin)) {
        //              scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
                        self.mainTable.scrollRectToVisible(activeTextFieldRect, animated:true)
                    }
    //            }
            }
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)

//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
        
        self.mainTable.contentInset = contentInsets
        self.mainTable.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
//        self.mainTable.scrollEnabled = true
//        scrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
//        self.mainTable.scrollEnabled = false
//        scrollView.scrollEnabled = false
    }
    
    // MARK: - Scroll
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if (scrollView.contentOffset.y < 0) {
//            self.mainTable.scrollEnabled = false
//        } else {
//            self.mainTable.scrollEnabled = true
//        }
        
//        if (scrollView.contentOffset.y < -20.0) {
//            println(scrollView.contentOffset.y)
//            var frame = CGRect(x: 0, y: 0, width: self.backgroundImage.frame.width, height: self.backgroundImage.frame.height + abs(scrollView.contentOffset.y))
//            self.backgroundImage.frame = frame
//            
//            frame.height = CGFloat(scrollView.contentOffset.y + 20.0)
//            self.backgroundImage.frame.origin.y = scrollView.contentOffset.y
//        }
//     //   self.updateHeaderView()
//    }
    
    func updateHeaderView() {
        var headRect = CGRect(x: 0, y: -211, width: self.mainTable.bounds.width, height: 211)
        if self.mainTable.contentOffset.y < -211 {
            headRect.origin.y = self.mainTable.contentOffset.y
            headRect.size.height = -self.mainTable.contentOffset.y
        }
        
        self.mainTable.tableHeaderView?.frame = headRect
        self.mainTable.tableHeaderView = self.mainTable.tableHeaderView
    }
}
