//
//  ProjectsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 09/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainTable: UITableView!
    var page: Int = -1
    var entries: [UAProject] = []
    var countEntries: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // add infinite load
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            // activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    /*
     * Infite load implementation
     */
    func infiniteLoad() {
        self.page += 1
        
        self.getEntries({() -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.infiniteScrollingView.stopAnimating()
        }, {() -> Void in
            println("Projects infinite load error")
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.infiniteScrollingView.stopAnimating()
        })
    }
    /*
     *  Pull to refresh implementation
     */
    func refresh() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.mainTable.pullToRefreshView.stopAnimating()
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        // url
        let url: String = "https://\(APIURL)/api/mobile/project/"

        // get entries
        Alamofire.request(.GET, url, parameters: ["page": page])
            .responseJSON { (_,_,JSON,errors) in
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    // error block
                    error()
                } else {
                    let ProjectModelView = UAProjectViewModel()
                    
                    // get get objects from JSON
                    var array = ProjectModelView.getProjectsFromJSON(JSON?.objectForKey("projects") as [Dictionary<String, AnyObject>])
                        
                    // merge two arrays
                    self.entries = self.entries + array
                    self.countEntries = self.entries.count
                    
                    success()
                }
        }
    }
}
