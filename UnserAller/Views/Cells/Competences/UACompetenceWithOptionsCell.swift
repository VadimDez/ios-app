//
//  UACompetenceWithOptionsCell.swift
//  UnserAller
//
//  Created by Vadym on 23/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACompetenceWithOptionsCell: UACompetenceCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var optionsTable: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.optionsTable.delegate = self
        self.optionsTable.dataSource = self
        
        self.registerNibs()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.competence != nil {
            return (self.competence as! UACompetenceWithOptions).options.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = (self.competence as! UACompetenceWithOptions).options[indexPath.row].name.getHeightForView(self.optionsTable.frame.width - 59, font: UIFont(name: "Helvetica Neue", size: 14)!)
        if height < 31 {
            return 31.0
        }
        
        return 10 + height
    }
    
    override func setupCell(competence: UACompetence) {
        self.competence = competence
        self.contentLabel.text = competence.content
        
        self.optionsTable.reloadData()
    }
}
