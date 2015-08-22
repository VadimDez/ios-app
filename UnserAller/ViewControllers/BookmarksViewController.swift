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
        
        let projectNameHeight = self.entries[indexPath.row].name.getHeightForView(288, font: UIFont(name: "Helvetica Neue", size: 17.0)!)
        
        if let companyName = self.entries[indexPath.row].company!.name {
            companyNameHeight = companyName.getHeightForView(288, font: UIFont(name: "Helvetica Neue Thin", size: 14.0)!)
        }
        
        return base + projectNameHeight + companyNameHeight
        
        //        return 206
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var competenceService = CompetenceService()
        competenceService.getEntries(self.entries[indexPath.row].id, success: { (competences) -> Void in
            if competences.count > 0 {
                var competenceVC = self.storyboard?.instantiateViewControllerWithIdentifier("CompetenceVC") as! CompetenceViewController
                competenceVC.projectId = self.entries[indexPath.row].id
                self.navigationController?.pushViewController(competenceVC, animated: true)
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                var projectViewController: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as! ProjectViewController
                
                // set project id
                projectViewController.projectId = self.entries[indexPath.row].id
                
                self.navigationController?.pushViewController(projectViewController, animated: true)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            }) { () -> Void in
                
        }
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
