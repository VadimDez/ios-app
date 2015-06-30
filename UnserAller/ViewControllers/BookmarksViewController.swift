//
//  BookmarksViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 10/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class BookmarksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mainTable: UITableView!
    var page: Int = -1
    var entries: [UAProject] = []
    var countEntries: Int = 0
    
    /** functions **/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        var UABookmarkCellNib = UINib(nibName: "UABookmarkCell", bundle: nil)
        
        self.registerNibs();
        
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        self.mainTable.triggerInfiniteScrolling()
    }
    
    func registerNibs() {
//        self.mainTable.registerNib(UABookmarkCellNib, forCellReuseIdentifier: "UABookmarkCell")
        
        var UAProjectCellNib = UINib(nibName: "UAProjectCell", bundle: nil)
        self.mainTable.registerNib(UAProjectCellNib, forCellReuseIdentifier: "UAProjectCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        
        if (self.mainTable.pullToRefreshView == nil) {
            // add refresh
            self.mainTable.addPullToRefreshWithActionHandler { () -> Void in
                // activity
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                self.refresh()
            }
        }
    }
    @IBAction func showMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell:UABookmarkCell? = self.mainTable.dequeueReusableCellWithIdentifier("UABookmarkCell") as? UABookmarkCell
//        
//        if (cell == nil) {
//            var nib:NSArray = NSBundle.mainBundle().loadNibNamed("UABookmarkCell", owner: self, options: nil)
//            
//            cell = nib.objectAtIndex(0) as? UABookmarkCell
//        }
//        
//        cell?.setCell(self.entries[indexPath.row])
//        
//        return cell!
        
        
        // bookmark
//        var cell:UABookmarkCell = self.mainTable.dequeueReusableCellWithIdentifier("UABookmarkCell") as! UABookmarkCell
//        
//        cell.setCell(self.entries[indexPath.row])
//        
//        return cell
        
        var cell:UAProjectCell = self.mainTable.dequeueReusableCellWithIdentifier("UAProjectCell") as! UAProjectCell
        
        cell.setCell(self.entries[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let base: CGFloat = 169.0
        var companyNameHeight: CGFloat = 0.0
        let projectNameHeight = self.getTextHeight(self.entries[indexPath.row].name, width: 288, fontSize: 17.0, fontName: "Helvetica Neue")
        
        if let companyName = self.entries[indexPath.row].company!.name {
            companyNameHeight = self.getTextHeight(companyName, width: 288, fontSize: 14.0, fontName: "Helvetica Neue Thin")
        }
        
        return base + projectNameHeight + companyNameHeight
        
        //        return 206
    }
    
    func getTextHeight(string: String, width: CGFloat, fontSize: CGFloat, fontName: String) -> CGFloat {
        // count text
        var frame: CGRect = CGRect()
        frame.size.width = width
        frame.size.height = CGFloat(MAXFLOAT)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = string
        label.font = UIFont(name: fontName, size: fontSize)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        return label.frame.size.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var projectVC: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as! ProjectViewController
        
        // set project id
        projectVC.projectId = self.entries[indexPath.row].id
        
        self.navigationController?.pushViewController(projectVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        // /api/mobile/profile/getbookmarks/
        let url: String = "\(APIURL)/api/mobile/profile/getbookmarks"
        
        Alamofire.request(.GET, url, parameters: ["page": page])
        .responseJSON { (_, _, JSON, errors) -> Void in
            if(errors != nil || JSON?.count == 0) {
                // print error
                println(errors)
                // error block
                error()
            } else {
                let ProjectModelView = UAProjectViewModel()
                
                // get get objects from JSON
                var array = ProjectModelView.getBookmarksFromJSON(JSON as! [Dictionary<String, AnyObject>])
                
                // merge two arrays
                self.entries = self.entries + array
                self.countEntries = self.entries.count
                
                success()
            }
        }
    }
    
    
    
    /*
     * Infite load implementation
     */
    func infiniteLoad() {
        self.page += 1
        
        self.getEntries({() -> Void in
            self.mainTable.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.infiniteScrollingView.stopAnimating()
            }, error: {() -> Void in
                println("Bookmarks infinite load error")
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.mainTable.infiniteScrollingView.stopAnimating()
        })
    }
    /*
     *  Pull to refresh implementation
     */
    func refresh() {
        self.page = 0
        self.entries = []
        self.countEntries = 0
        
        self.getEntries({() -> Void in
            self.mainTable.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.pullToRefreshView.stopAnimating()
            }, error: {() -> Void in
                println("Bookmarks pull to refresh load error")
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.mainTable.pullToRefreshView.stopAnimating()
        })
    }
}
