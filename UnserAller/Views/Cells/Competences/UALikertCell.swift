//
//  UALikertCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UALikertCell: UACompetenceCell, UITableViewDelegate, UITableViewDataSource {
    
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
        var UAOptionsCellNib = UINib(nibName: "UAOptionsCell", bundle: nil)
        self.optionsTable.registerNib(UAOptionsCellNib, forCellReuseIdentifier: "UAOptionsCell")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UAOptionsCell = self.optionsTable.dequeueReusableCellWithIdentifier("UAOptionsCell") as! UAOptionsCell
        cell.contentLabel.text = "LIKERT OPTION \(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.optionsTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    func setupCell(competence: UACompetence) {
        self.contentLabel.text = "likert competence"
    }
    
    override func validate() -> Bool {
        let count = self.optionsTable.numberOfRowsInSection(0)
        var isValid = false
        var i = 0
        
        // loop through option cells
        while (!isValid && i < count) {
            let index = NSIndexPath(forRow: i, inSection: 0)
            isValid = (self.optionsTable.cellForRowAtIndexPath(index) as! UAOptionsCell).validate()
            i++
        }
        
        return isValid
    }


}
