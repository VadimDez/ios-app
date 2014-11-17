//
//  ActivityViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainTable: UITableView!
    var entries: [UASuggestion] = []
    var countEntries: Int = 0
    var page: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTable.dataSource = self
        self.mainTable.delegate = self
        
        
        // register nibs
        var UASuggestCellNib = UINib(nibName: "UASuggestCell", bundle: nil)
        self.mainTable.registerNib(UASuggestCellNib, forCellReuseIdentifier: "UASuggestionCell")
        
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        self.mainTable.triggerInfiniteScrolling()
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        toggleSideMenuView()
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

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UASuggestionCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as UASuggestionCell

        cell.setCellForHome(self.entries[indexPath.row])

        return cell
//        return UITableViewCell()
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
                println("Activity infinite load error")
                
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
                println("Activity pull to refresh load error")
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.mainTable.pullToRefreshView.stopAnimating()
        })
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        // /api/mobile/profile/getbookmarks/
        let url: String = "https://\(APIURL)/api/mobile/profile/getactivity"
        
        Alamofire.request(.GET, url, parameters: ["page": page])
            .responseJSON { (_, _, JSON, errors) -> Void in
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    // error block
                    error()
                } else {
                    let SuggestionViewModel = UASuggestionViewModel()

                    // get get objects from JSON
                    var array = SuggestionViewModel.getSuggestionsForActivityFromJSON(JSON as [Dictionary<String, AnyObject>])
                    // merge two arrays
                    self.entries = self.entries + array
                    self.countEntries = self.entries.count
                    
                    success()
                }
        }
    }
}
