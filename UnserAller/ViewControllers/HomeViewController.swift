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
    var countEntries: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // adjust table Or use didMoveToParentViewController
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.edgesForExtendedLayout = UIRectEdge.None
        
        // hide nav bar
//        self.navigationController?.hidesBarsOnSwipe = true
        
        
//        self.getEntries({
//            
//        }, error: { () -> Void in
//            
//        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup infinite scrolling
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        
        // set row height
//        self.mainTable.rowHeight = UITableViewAutomaticDimension
        
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
        self.countEntries = 0
        
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
        var cell: UITableViewCell
        
        // idk why this happening!
        if(self.entries.count == 0) {
            println("accessing with no elements")
            return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        if ("SuggestionCell" == entries[indexPath.row].cellType) {
            cell = self.getSuggestCellForHome(entries[indexPath.row])
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.textLabel.text = "\(indexPath.row)"
        }
        
        return cell
    }
    
    
    /**
     *  Get suggestion cell with suggestion object
     */
    func getSuggestCellForHome(suggestion: UASuggestion) -> UASuggestionCell {
//        var cell: UASuggestionCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as UASuggestionCell//UASuggestionCell()
        
        var cell:UASuggestionCell? = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as? UASuggestionCell
        
        if (cell == nil) {
            var nib:NSArray = NSBundle.mainBundle().loadNibNamed("UASuggestCell", owner: self, options: nil)
            
            cell = nib.objectAtIndex(0) as? UASuggestionCell
        }
        
        cell?.setCellForHome(suggestion)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let base: CGFloat = 110.0
        
        // count text
        var frame: CGRect = CGRect()
        frame.size.width = 290
        frame.size.height = CGFloat(MAXFLOAT)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = entries[indexPath.row].content
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        return base + label.frame.size.height
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
                self.countEntries = self.entries.count
                
                success()
            }
        }
    }
}