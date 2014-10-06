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
    var refreshControl:UIRefreshControl!
    var rowsLoaded: Int = 0
    var loadMoreStatus = false
    var page: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // adjust table
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.None
        
        // hide nav bar
        self.navigationController?.hidesBarsOnSwipe = true
        
        self.getEntries({
            
        }, error: { () -> Void in
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup pull to refresh
        self.mainTable.addPullToRefreshWithActionHandler { () -> Void in
            self.refresh()
        }
        
        // setup infinite scrolling
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            self.infiniteLoad()
        }
        
    }
    
    func refresh() {
        sleep(1)
        println("ok")
        self.mainTable.pullToRefreshView.stopAnimating()
    }
    func infiniteLoad() {
        sleep(1)
        println("finished loading")
        self.mainTable.infiniteScrollingView.stopAnimating();
    }
    

    @IBAction func showMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsLoaded
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
            if(errors != nil) {
                // print error
                println(errors)
                // error block
                error()
            } else {
                if(JSON?.count > 0 && JSON?.objectAtIndex(0).count > 0) {
                    
                    let SuggestionModelView = UASuggestionViewModel()
                    
                    // get get objects from JSON
                    var array = SuggestionModelView.getSuggestionsFromJSON(JSON as [Dictionary<String, AnyObject>])
                    
                    success()
                }
            }
        }
    }
}