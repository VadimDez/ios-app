//
//  UACheckboxCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACheckboxCell: UACompetenceCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var optionsTable: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.optionsTable.delegate = self
        self.optionsTable.dataSource = self
        
        self.registerNibs()
    }
    
    /**
    Register nibs
    */
    func registerNibs() {
        // freetext
        var UAOptionCellNib = UINib(nibName: "UAOptionCell", bundle: nil)
        self.optionsTable.registerNib(UAOptionCellNib, forCellReuseIdentifier: "UAOptionCell")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UAOptionCell = self.optionsTable.dequeueReusableCellWithIdentifier("UAOptionCell") as! UAOptionCell
        
        if let option = self.competence.options[indexPath.row] as? Dictionary<String, AnyObject> {
            if let name: String = option["name"] as? String {
                cell.label.text = "\(name)"
            }
            
            if let val: Int = option["value"] as? Int {
                cell.label.tag = val
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // toggle
        var cell = self.optionsTable.cellForRowAtIndexPath(indexPath) as! UAOptionCell
        cell.toggle(!cell.toggled)
        self.optionsTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.competence.options.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func setupCell(competence: UACompetence) {
        self.competence = competence
        self.contentLabel.text = competence.content
        
        self.optionsTable.reloadData()
    }
    
    override func validate() -> Bool {
        let count = self.optionsTable.numberOfRowsInSection(0)
        var isToggled = false
        var i = 0
        
        // loop through option cells
        while (!isToggled && i < count) {
            let index = NSIndexPath(forRow: i, inSection: 0)
            isToggled = (self.optionsTable.cellForRowAtIndexPath(index) as! UAOptionCell).toggled
            i++
        }
        
        return isToggled
    }

}
