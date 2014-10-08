//
//  HomeViewController.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

//import Foundation
import UIKit
import Alamofire


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainTable: UITableView!
    var page: Int = 0
    var entries: [UASuggestion] = []
    let maxResponse: UInt = 10
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // adjust table Or use didMoveToParentViewController
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.edgesForExtendedLayout = UIRectEdge.None
        
        // hide nav bar
//        self.navigationController?.hidesBarsOnSwipe = true
        
        self.getEntries({
            
        }, error: { () -> Void in
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup infinite scrolling
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        self.mainTable.triggerInfiniteScrolling()
        
    }
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        
        if (self.mainTable.pullToRefreshView == nil) {
            // setup pull to refresh
            self.mainTable.addPullToRefreshWithActionHandler { () -> Void in
                
                // active activity indicator
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                self.refresh()
            }
        }
    }
    
    func refresh() {
        self.page = 0
        self.entries = []
        
        self.getEntries({ () -> Void in
            self.mainTable.reloadData()
            
            self.mainTable.pullToRefreshView.stopAnimating()
            
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }, error: { () -> Void in
            println("Homepage error")
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    /**
     *  Load next page
     */
    func infiniteLoad() {
        // increment page
        self.page += 1
        
        self.getEntries({ () -> Void in
            // reload data
            self.mainTable.reloadData()
            
            self.mainTable.infiniteScrollingView.stopAnimating()
            
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }, error: { () -> Void in
            println("Homepage error")
            
            self.mainTable.infiniteScrollingView.stopAnimating()
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    

    /**
     *  Hide menu button
     */
    @IBAction func showMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func getEntries(success:() -> Void, error: () -> Void) {
        // build URL
        let url: String = "http://\(APIURL)/api/mobile/profile/getwall"
        
        // get entries
        Alamofire.request(.GET, url, parameters: ["page": page])
        .responseJSON { (_,_,JSON,errors) in
            if(errors != nil || JSON?.count == 0 || JSON?.objectAtIndex(0).count == 0) {
                // print error
                println(errors)
                // error block
                error()
            } else {
                let SuggestionModelView = UASuggestionViewModel()

                // get get objects from JSON
                var array = SuggestionModelView.getSuggestionsFromJSON(JSON as [Dictionary<String, AnyObject>])
            
                // merge two arrays
                self.entries = self.entries + array
                
                success()
            }
        }
    }
}