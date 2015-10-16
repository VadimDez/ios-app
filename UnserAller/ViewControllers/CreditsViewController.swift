//
//  CreditsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 10/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class CreditsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var mainTable: UITableView!
    var page: Int = -1
    var countEntries = 0
    var entries: [UACredit] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // register nibs
        let UACreditCellNib = UINib(nibName: "UACreditCell", bundle: nil)
        self.mainTable.registerNib(UACreditCellNib, forCellReuseIdentifier: "UACreditCell")

        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        self.mainTable.triggerInfiniteScrolling()
    }
    @IBAction func showMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
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
        let cell:UACreditCell = self.mainTable.dequeueReusableCellWithIdentifier("UACreditCell") as! UACreditCell
        
        cell.setCell(self.entries[indexPath.row])
        
        return cell
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
            },error:  {() -> Void in
                print("Credit infinite load error", terminator: "")
                
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
                print("Credit pull to refresh load error", terminator: "")
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.mainTable.pullToRefreshView.stopAnimating()
        })
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        // /api/mobile/profile/getbookmarks/
        let url: String = "\(APIURL)/api/mobile/profile/getcredits"

        Alamofire.request(.GET, url, parameters: ["page": page])
            .responseJSON { (_, _, result) -> Void in
                
                switch result {
                case .Success(let JSON) :
                    if JSON.count != 0 {
                        
                        let CreditViewModel = UACreditViewModel()
                        
                        // get get objects from JSON
                        let array = CreditViewModel.getCreditsFromJSON(JSON as! [Dictionary<String, AnyObject>])
                        // merge two arrays
                        self.entries = self.entries + array
                        self.countEntries = self.entries.count
                        
                        success()
                    } else {
                        // error block
                        error()
                    }
                    
                case .Failure(_, let errors) :
                    
                    // print error
                    print(errors)
                    // error block
                    error()
                }
        }
    }
}
