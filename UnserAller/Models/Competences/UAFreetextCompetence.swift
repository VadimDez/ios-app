//
//  UAFreetextCompetence.swift
//  UnserAller
//
//  Created by Vadym on 16/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UAFreetextCompetence: UACompetence {
    
    override init() {
        super.init()
        self.format = CompetenceFormat.Placeholder
        self.cellType = "UAFreetextCell"
    }
    
    override func getAnswer() -> [Dictionary<String, AnyObject>] {
        return [
            [
                "competence": self.id,
                "value": "read"
            ]
        ]
    }
}