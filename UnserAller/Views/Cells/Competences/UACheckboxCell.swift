//
//  UACheckboxCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACheckboxCell: UACompetenceWithOptionsCell {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        (self.competence as! UACheckboxCompetence).options[indexPath.row].isSelected = !(self.competence as! UACheckboxCompetence).options[indexPath.row].isSelected
        
        self.optionsTable.deselectRowAtIndexPath(indexPath, animated: false)
        self.optionsTable.reloadData()
    }
}
