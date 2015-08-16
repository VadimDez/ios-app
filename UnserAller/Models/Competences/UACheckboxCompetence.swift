//
//  UACheckboxCompetence.swift
//  UnserAller
//
//  Created by Vadym on 16/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UACheckboxCompetence: UACompetenceWithOptions {
    
    override init() {
        super.init()
        self.format = CompetenceFormat.Checkbox
        self.cellType = "UACheckboxCell"
    }
    
    override func getAnswer() -> [Dictionary<String, AnyObject>] {
        var array: [Dictionary<String, AnyObject>] = []
        
        for option in (self as UACompetenceWithOptions).options {
            if (option.isSelected) {
                array.append(["id": self.id, "value": option.value])
            }
        }
        
        return array
    }
}