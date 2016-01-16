//
//  UACompetence.swift
//  UnserAller
//
//  Created by Vadym on 10/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

enum CompetenceFormat {
    case Placeholder, SingleLineInput, MultipleLineInput, Options, Checkbox, Likert
}

class UACompetence {
    var id: UInt!
    var name: String!
    var format: CompetenceFormat!
    var content: String!
    var inputValue: String!
    var config: String!
//    var options: [Dictionary<String, AnyObject>] = []
    var cellType: String!
    
    init() {
        
    }
    
    func validate() -> Bool {
        return true
    }
    
    func getFormat() -> CompetenceFormat {
        return self.format
    }
    
    func getAnswer() -> [Dictionary<String, AnyObject>] {
        return [Dictionary()]
    }
}