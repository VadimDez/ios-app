//
//  UAOptionsCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAOptionsCell: UACompetenceWithOptionsCell {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let count = (self.competence as! UACompetenceWithOptions).options.count
        
        // toggle all
        for (var i = 0; i < count; i++) {
            (self.competence as! UACompetenceWithOptions).options[i].isSelected = false
        }
        
        // toggle
        (self.competence as! UACompetenceWithOptions).options[indexPath.row].isSelected = true
        self.optionsTable.deselectRowAtIndexPath(indexPath, animated: false)
        self.optionsTable.reloadData()
    }
}
