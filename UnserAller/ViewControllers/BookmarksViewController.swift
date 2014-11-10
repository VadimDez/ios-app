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
        
        var nib = UINib(nibName: "UABookmarkCell", bundle: nil)
        
        self.mainTable.registerNib(nib, forCellReuseIdentifier: "UABookmarkCell")
        
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        self.mainTable.triggerInfiniteScrolling()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        var cell:UABookmarkCell = self.mainTable.dequeueReusableCellWithIdentifier("UABookmarkCell") as UABookmarkCell
        
        cell.setCell(self.entries[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UABookmarkCell = tableView.cellForRowAtIndexPath(indexPath) as UABookmarkCell
        cell.frame.size.height = 500
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        // /api/mobile/profile/getbookmarks/
        let url: String = "https://\(APIURL)/api/mobile/profile/getbookmarks"
        
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
                var array = ProjectModelView.getBookmarksFromJSON(JSON as [Dictionary<String, AnyObject>])
                
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
            }, {() -> Void in
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
            }, {() -> Void in
                println("Bookmarks pull to refresh load error")
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.mainTable.pullToRefreshView.stopAnimating()
        })
    }
}
