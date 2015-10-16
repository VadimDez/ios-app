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
    // credits labels
    @IBOutlet weak var suggesitonCredits: UILabel!
    @IBOutlet weak var commentCredits: UILabel!
    @IBOutlet weak var likeCredits: UILabel!
    @IBOutlet weak var voteCredits: UILabel!
    
    
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
        
        // bg image
        let tempImageView: UIImageView = UIImageView(image: UIImage(named: "background-1"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView
        
        self.tableView.scrollsToTop = false
        self.tableView.scrollEnabled = false
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    /**
    *  Setup profile image
    */
    func setupProfileImage() {
        let imageLayer:CALayer = self.profileImage.layer
        imageLayer.cornerRadius = 30
        imageLayer.masksToBounds = true
    }
    
    /**
    Set profile data
    */
    func setProfileData() {
        let user = UAUser()
        let sharedUser = UserShared.sharedInstance
        
        self.setupProfileImage()
        
        user.getFromAPI { (user, credits) -> Void in
            
            self.userName.text = "\(user.firstname) \(user.lastname)"
            self.loadProfileImage(user.id.unsignedLongValue)

            // set user id
            sharedUser.setId(user.id.unsignedLongValue)
            
            if let suggestionCredits: AnyObject = credits["suggestions"] {
                sharedUser.setSuggestionCredits(UInt(suggestionCredits.integerValue))
                self.suggesitonCredits.text = "\(sharedUser.suggestionCredits)"
            }
            
            if let commentCredits: AnyObject = credits["comments"] {
                sharedUser.setCommentCredits(UInt(commentCredits.integerValue))
                self.commentCredits.text = "\(sharedUser.commentCredits)"
            }
            
            if let likesCredits: AnyObject = credits["likes"] {
                sharedUser.setSuggestionCredits(UInt(likesCredits.integerValue))
                self.likeCredits.text = "\(sharedUser.likeCredits)"
            }
            
            if let votesCredits: AnyObject = credits["votes"] {
                sharedUser.setSuggestionCredits(UInt(votesCredits.integerValue))
                self.voteCredits.text = "\(sharedUser.voteCredits)"
            }
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MenuCell")
            
        }
        // set text color
        cell!.textLabel?.textColor = UIColor.whiteColor()
        cell!.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
        // set text
        cell!.textLabel?.text = menuItems[indexPath.row]
        // set icon
        cell?.imageView?.image = UIImage(named: menuItems[indexPath.row])
        
//        if let imageView: UIImageView = cell?.imageView {
//            let decrement: CGFloat = 8.0
//            let rect = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y - decrement - 50, width: imageView.frame.width - decrement * 2, height: imageView.frame.height - decrement * 2)
//            
//            cell?.imageView?.frame = rect
//        }
        
        
        cell?.backgroundColor = UIColor.clearColor()
        
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor(white: 1, alpha: 0.1)
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
            }) { (request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
    }
}