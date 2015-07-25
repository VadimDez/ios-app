//
//  MenuTableViewController.swift
//  UnserAller
//
//  Created by Vadym on 04/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//


import UIKit
import CoreData

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    var selectedMenuItem : Int = 0
    let menuItems: [String] = ["Wall", "Projects", "Credits", "Bookmarks","Activity", "Settings"]
    
    override func viewDidLoad() {
        
        self.setupTableView()
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.setProfileData()
        
        super.viewDidLoad()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    /**
     *  Setup table view
     */
    func setupTableView() {
        // Customize apperance of table view
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) //
//        self.tableView.separatorStyle = .None
//        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.scrollsToTop = false
        self.tableView.scrollEnabled = false
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    /**
    *  Setup profile image
    */
    func setupProfileImage() {
        var imageLayer:CALayer = self.profileImage.layer
        imageLayer.cornerRadius = 30
        imageLayer.masksToBounds = true
    }
    
    /**
    Set profile data
    */
    func setProfileData() {
        var user = UAUser()
        
        self.setupProfileImage()
        
        user.getFromAPI { (user) -> Void in
            self.userName.text = "\(user.firstname) \(user.lastname)"
            self.loadProfileImage(user.id.unsignedLongValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MenuCell")
            
        }
        // set text color
        cell!.textLabel?.textColor = UIColor.whiteColor()
        // set text
        cell!.textLabel?.text = menuItems[indexPath.row]
        // set icon
        cell?.imageView?.image = UIImage(named: menuItems[indexPath.row])
        
        
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.9)
        cell!.selectedBackgroundView = selectedBackgroundView
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == selectedMenuItem) { // if already selected - toggle
            
            self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
            return
        }
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = self.getNavigationByIdentifier("initNavigation")
            break
        case 1:
            destViewController = self.getNavigationByIdentifier("projectsNavi")
            break
        case 2:
            destViewController = self.getNavigationByIdentifier("creditsNavi")
            break
        case 3:
            destViewController = self.getNavigationByIdentifier("bookmarksNavi")
            break
        case 4:
            destViewController = self.getNavigationByIdentifier("activityNavi")
            break
        case 5:
            destViewController = self.getNavigationByIdentifier("settingsNavi")
            break
        default:
            destViewController = self.getNavigationByIdentifier("initNavigation")
            break
        }
        
        self.evo_drawerController?.setCenterViewController(destViewController, withCloseAnimation: true, completion: nil)
    }
    
    func getNavigationByIdentifier(identifier: String) -> UINavigationController {
        return self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as! UINavigationController
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    /**
     * Load profile image
     */
    func loadProfileImage(id: UInt) {
        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "\(APIURL)/media/profileimage/\(id)/80/80")!)
        self.profileImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            // test
            if let weakSelf = self {
                weakSelf.profileImage.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
    }
}