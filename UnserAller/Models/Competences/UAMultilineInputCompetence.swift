//
//  UAMultilineInputCompetence.swift
//  UnserAller
//
//  Created by Vadym on 16/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UAMultilineInputCompetence: UACompetence {
    var answer: String = ""
    
    override init() {
        super.init()
        self.format = CompetenceFormat.MultipleLineInput
        self.cellType = "UAMultipleLineInputCell"
    }
    
    override func validate() -> Bool {
        return (count(self.answer) > 0)
    }
    override func getAnswer() -> [Dictionary<String, AnyObject>] {
        return [["competence": self.id, "value": self.answer]]
    }
}