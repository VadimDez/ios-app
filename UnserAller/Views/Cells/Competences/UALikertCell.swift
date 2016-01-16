//
//  UALikertCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UALikertCell: UACompetenceWithOptionsCell {
    
    var showContent: Bool = true
    
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
    override func registerNibs() {
        var UAOptionsCellNib = UINib(nibName: "UAOptionsCell", bundle: nil)
        self.optionsTable.registerNib(UAOptionsCellNib, forCellReuseIdentifier: "UAOptionsCell")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UAOptionsCell = self.optionsTable.dequeueReusableCellWithIdentifier("UAOptionsCell") as! UAOptionsCell
        
        cell.setupCell(self.competence)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.optionsTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.competence != nil) ? 1 : 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let width = self.optionsTable.frame.width
        let font = UIFont(name: "Helvetica Neue", size: 14)
        var height: CGFloat = 15.0 // base
        
        if self.showContent {
            height = height + self.competence.content.getHeightForView(width - 16, font: font!)
        } else {
            height = height + 20.0
        }
        
        // height for question
        height = height + 10.0 + self.competence.content.getHeightForView(width - 16, font: font!)
        
        let count = (self.competence as! UACompetenceWithOptions).options.count
        
        for (var i = 0; i < count; i++) {
            let optionHeight = (self.competence as! UACompetenceWithOptions).options[i].name.getHeightForView(width - 59, font: font!)
            
            if optionHeight < 31 {
                height = height + 31
            } else {
                height = height + 10.0 + optionHeight
            }
        }
        
        return height
    }
    
    override func setupCell(competence: UACompetence) {
        self.competence = competence
        
        if self.showContent {
            self.contentLabel.text = competence.content
        } else {
            self.contentLabel.text = ""
            self.contentLabel.frame = CGRect(x: self.contentLabel.frame.origin.x, y: self.contentLabel.frame.origin.y, width: self.contentLabel.frame.width, height: 0)
        }
        
        self.optionsTable.reloadData()
    }
}
