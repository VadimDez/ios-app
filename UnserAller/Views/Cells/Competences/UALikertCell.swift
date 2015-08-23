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
        var UAOptionsCellNib = UINib(nibName: "UAOptionsCell", bundle: nil)
        self.optionsTable.registerNib(UAOptionsCellNib, forCellReuseIdentifier: "UAOptionsCell")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UAOptionsCell = self.optionsTable.dequeueReusableCellWithIdentifier("UAOptionsCell") as! UAOptionsCell
        cell.setupCell(self.competence)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.optionsTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    override func setupCell(competence: UACompetence) {
        self.competence = competence
        self.contentLabel.text = competence.content
        
        self.optionsTable.reloadData()
    }
}
