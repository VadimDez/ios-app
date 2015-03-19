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
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    
    
    var selectedMenuItem : Int = 0
    let menuItems: [String] = ["Wall", "Projects", "Credits", "Bookmarks","Activity", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.scrollsToTop = false
        self.tableView.scrollEnabled = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
        self.setProfileData()
    }
    
    /**
    Set profile data
    */
    func setProfileData() {
        var user: UAUser = UAUser()
        user.getUserInfo { () -> Void in
            var error: NSError?
            let managedContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            
            // fetch request
            let fetchRequest = NSFetchRequest(entityName: "User")
            
            // perform fetch
            if let results = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [User] {
                if (results.count > 0) {
                    let mainUser = results[0] as User
                    println("================================================================================================")
                    println(results[0] as User)
//                    self.firstName.text = mainUser.firstname
                }
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MenuCell")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        cell!.textLabel?.text = menuItems[indexPath.row]// "ViewController #\(indexPath.row+1)"
        
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
            destViewController = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as UINavigationController
            break
        case 1:
            destViewController = self.storyboard?.instantiateViewControllerWithIdentifier("projectsNavi") as UINavigationController
            break
        case 2:
            destViewController = self.storyboard?.instantiateViewControllerWithIdentifier("creditsNavi") as UINavigationController
            break
        case 3:
            destViewController = self.storyboard?.instantiateViewControllerWithIdentifier("bookmarksNavi") as UINavigationController
            break
        case 4:
            destViewController = self.storyboard?.instantiateViewControllerWithIdentifier("activityNavi") as UINavigationController
            break
        case 5:
            destViewController = self.storyboard?.instantiateViewControllerWithIdentifier("settingsNavi") as UINavigationController
            break
        default:
            destViewController = self.storyboard?.instantiateViewControllerWithIdentifier("initNavigation") as UINavigationController
            break
        }
        
        self.evo_drawerController?.setCenterViewController(destViewController, withCloseAnimation: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
}