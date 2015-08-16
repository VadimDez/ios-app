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
}