//
//  CompetenceViewController.swift
//  UnserAller
//
//  Created by Vadym on 28/07/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class CompetenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainTable: UITableView!
    
    var entries: [UACompetence] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNibs()
        self.getEntries({ () -> Void in
            self.mainTable.reloadData()
        }, error: { () -> Void in
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Register nibs
    */
    func registerNibs() {
        // freetext
        var UAFreetextCellNib = UINib(nibName: "UAFreetextCell", bundle: nil)
        self.mainTable.registerNib(UAFreetextCellNib, forCellReuseIdentifier: "UAFreetextCell")
        // single line input
        var UASingleLineInputCellNib = UINib(nibName: "UASingleLineInputCell", bundle: nil)
        self.mainTable.registerNib(UASingleLineInputCellNib, forCellReuseIdentifier: "UASingleLineInputCell")
        // multiple line input
        var UAMultipleLineInputCellNib = UINib(nibName: "UAMultipleLineInputCell", bundle: nil)
        self.mainTable.registerNib(UAMultipleLineInputCellNib, forCellReuseIdentifier: "UAMultipleLineInputCell")
        // options
        var UAOptionsNib = UINib(nibName: "UAOptionsCell", bundle: nil)
        self.mainTable.registerNib(UAOptionsNib, forCellReuseIdentifier: "UAOptionsCell")
        // checkbox
        var UACheckboxCellNib = UINib(nibName: "UACheckboxCell", bundle: nil)
        self.mainTable.registerNib(UACheckboxCellNib, forCellReuseIdentifier: "UACheckboxCell")
        // likert
        var UALikertCellNib = UINib(nibName: "UALikertCell", bundle: nil)
        self.mainTable.registerNib(UALikertCellNib, forCellReuseIdentifier: "UALikertCell")
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
        return self.getCell(indexPath.row)
    }
    
    func getCell(index: Int) -> UITableViewCell {
        
        if (self.entries[index].format == "placeholder") {
            var cell = self.mainTable.dequeueReusableCellWithIdentifier("UAFreetextCell") as! UAFreetextCell
                cell.setupCell(self.entries[index])
            
            return cell
        }
        
        if (self.entries[index].format == "input") {
            
            var cell = self.mainTable.dequeueReusableCellWithIdentifier("UASingleLineInputCell") as! UASingleLineInputCell
            cell.setupCell(self.entries[index])
            
            return cell
        }
        
        if (self.entries[index].format == "textarea") {
            var cell = self.mainTable.dequeueReusableCellWithIdentifier("UAMultipleLineInputCell") as! UAMultipleLineInputCell
            cell.setupCell(self.entries[index])
            
            return cell
        }
        
        if (self.entries[index].format == "options") {
            var cell = self.mainTable.dequeueReusableCellWithIdentifier("UAOptionsCell") as! UAOptionsCell
            cell.setupCell(self.entries[index])
            
            return cell
        }
        
        if (self.entries[index].format == "checkbox") {
            var cell = self.mainTable.dequeueReusableCellWithIdentifier("UACheckboxCell") as! UACheckboxCell
            cell.setupCell(self.entries[index])
            
            return cell
        }
        
        
        if (self.entries[index].format == "likert") {
            var cell = self.mainTable.dequeueReusableCellWithIdentifier("UALikertCell") as! UALikertCell
            cell.setupCell(self.entries[index])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 600.0
        }
        
        if (indexPath.row >= 3) {
            return 150.0
        }
        
        if (indexPath.row >= 1) {
            return 80.0
        }
        
        return 30.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "asd"
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        var url = "\(APIURL)/api/mobile/competence/get"
        
        Alamofire.request(.GET, url, parameters: ["project": 1])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    // error block
                    error()
                } else {
                    let competenceService = CompetenceService()
                    
                    // get get objects from JSON
                    var array = competenceService.getCompetencesFromJSON(JSON?.objectForKey("competences") as! [Dictionary<String, AnyObject>])

                    // merge two arrays
                    self.entries = self.entries + array
                    
                    success()
                }
        }
    }
}
