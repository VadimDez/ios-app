//
//  UACompetenceWithOptions.swift
//  UnserAller
//
//  Created by Vadym on 16/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UACompetenceWithOptions: UACompetence {
    var options: [UAOption] = []
    
    override func validate() -> Bool {
        var isSelected = false
        let count = self.options.count
        var i = 0
        
        while i < count && !isSelected {
            isSelected = self.options[i].isSelected
            i++
        }
        
        return isSelected
    }
    
    
    override func getAnswer() -> [Dictionary<String, AnyObject>] {
        var selectedOption: UAOption!
        let options: [UAOption] = self.options
        let count = options.count
        var found = false
        var i = 0
        
        while (!found && i < count) {
            if options[i].isSelected {
                selectedOption = options[i]
                found = true
            }
            
            i++
        }
        
        return [["id": self.id, "value": selectedOption.value]]
    }
}