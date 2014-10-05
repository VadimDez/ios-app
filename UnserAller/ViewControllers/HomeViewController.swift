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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // hide nav bar
        self.navigationController?.hidesBarsOnSwipe = true
        
        //
        rowsLoaded = 20
        
        var footer = UIView()
        footer.frame.size.height = 100.0
        
        var activity = UIActivityIndicatorView()
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activity.startAnimating()
        activity.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight)
        activity.frame.origin.y = 50
        
        footer.addSubview(activity)
        
        self.mainTable.tableFooterView = footer
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.mainTable.addSubview(refreshControl)
        
        self.mainTable.tableFooterView?.hidden = true
    }
    
    func refresh(sender:AnyObject) {
        rowsLoaded = 20
        println("refreshed")
        self.refreshControl.endRefreshing()
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
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        if(indexPath.row > rowsLoaded - 7) {
//            println("more")
//            rowsLoaded = rowsLoaded + 10
//            self.mainTable.reloadData()
//        }
//    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            loadMore()
        }
    }
    
    func loadMore() {
        if ( !loadMoreStatus ) {
            self.loadMoreStatus = true
//            self.activityIndicator.startAnimating()
            self.mainTable.tableFooterView?.hidden = false
            loadMoreBegin("Load more",
                loadMoreEnd: {(x:Int) -> () in
                    self.mainTable.reloadData()
                    self.loadMoreStatus = false
//                    self.activityIndicator.stopAnimating()
                    self.mainTable.tableFooterView?.hidden = true
            })
        }
    }
    
    func loadMoreBegin(newtext:String, loadMoreEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            println("loadmore")
//            self.text = newtext
            self.rowsLoaded += 20
            sleep(2)
            
            dispatch_async(dispatch_get_main_queue()) {
                loadMoreEnd(0)
            }
        }
    }
}