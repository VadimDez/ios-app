//
//  UASuggestionViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 14/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class UASuggestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mainTable: UITableView!
    
    var active: Bool!
    var suggestion: UASuggestion!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        self.getSuggestion({ () -> Void in
            
        }, failure: { () -> Void in
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        cell.textLabel?.text = "comments"
        return cell
    }
    
    /**
     *  Load suggestion
     */
    func getSuggestion(success: () -> Void, failure: () -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "http://\(APIURL)/api/mobile/suggestion/suggestion"

        Alamofire.request(.GET, url, parameters: ["id": self.suggestion.suggestionId])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println("get suggestion error")
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    let suggestionViewModel = UASuggestionViewModel()
                    
                    self.suggestion = UASuggestion().getSuggestionFromJSONForSuggestionVC(JSON?.objectAtIndex(0) as Dictionary<String, AnyObject>)
                    
                    success()
                }
        }

    }

}
