//
//  UAOptionsCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAOptionsCell: UACompetenceCell, UITableViewDelegate, UITableViewDataSource {
    
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
        cell.label.text = "OPTION \(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let count = self.optionsTable.numberOfRowsInSection(0)
        
        // toggle all
        for (var i = 0; i < count; i++) {
            let index = NSIndexPath(forRow: i, inSection: 0)
            (self.optionsTable.cellForRowAtIndexPath(index) as! UAOptionCell).toggle(false)
        }
        
        // toggle
        (self.optionsTable.cellForRowAtIndexPath(indexPath) as! UAOptionCell).toggle(true)
        self.optionsTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func setupCell(competence: UACompetence) {
        self.contentLabel.text = "qqq"
    }
    
    override func validate() -> Bool {
        let count = self.optionsTable.numberOfRowsInSection(0)
        var isToggled = false
        var i = 0
        
        // loop through option cells
        while (!isToggled && i < count) {
            let index = NSIndexPath(forRow: i, inSection: 0)
            (self.optionsTable.cellForRowAtIndexPath(index) as! UAOptionCell).toggle(false)
            i++
        }
        
        return isToggled
    }
}
