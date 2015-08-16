//
//  UASingleInputCompetence.swift
//  UnserAller
//
//  Created by Vadym on 16/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UASingleInputCompetence: UACompetence {
    var answer: String = ""
    
    override init() {
        super.init()
        
        self.format = "input"
    }
    
    override func validate() -> Bool {
        return (count(self.answer) > 0)
    }
}