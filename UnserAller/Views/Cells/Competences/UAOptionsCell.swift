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
        let option: UAOption = (self.competence as! UACompetenceWithOptions).options[indexPath.row]
        
        cell.toggle(option.isSelected)
        cell.label.text = option.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let count = self.optionsTable.numberOfRowsInSection(0)
        
        // toggle all
        for (var i = 0; i < count; i++) {
            (self.competence as! UACompetenceWithOptions).options[i].isSelected = false
        }
        
        // toggle
        (self.competence as! UACompetenceWithOptions).options[indexPath.row].isSelected = true
        self.optionsTable.deselectRowAtIndexPath(indexPath, animated: false)
        self.optionsTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.competence != nil {
            return (self.competence as! UACompetenceWithOptions).options.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func setupCell(competence: UACompetence) {
        self.competence = competence
        self.contentLabel.text = competence.content
        
        self.optionsTable.reloadData()
    }
}
