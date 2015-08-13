//
//  CompetenceService.swift
//  UnserAller
//
//  Created by Vadym on 13/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class CompetenceService {
    
    func getCompetencesFromJSON(data: [Dictionary<String, AnyObject>]) -> [UACompetence] {
        var competences: [UACompetence] = []
        
        for object in data {
            competences.append(self.getCompetenceFromJSON(object))
        }
        
        return competences
    }
    
    func getCompetenceFromJSON(object: Dictionary<String, AnyObject>) -> UACompetence {
        var competence: UACompetence = UACompetence()
        
        if let id = object["id"] as? UInt {
            competence.id = id
        }

        if let name = object["name"] as? String {
            competence.name = name
        }
        
        if let content = object["content"] as? String {
            competence.content = content
        }
        
        if let format = object["format"] as? String {
            competence.format = format
            
            if (format == "options" || format == "checkbox" || format == "likert") {
                if let config = object["config"] as? Dictionary<String, AnyObject> {
                    if let options = config["options"] as? [Dictionary<String, AnyObject>] {
                        competence.options = options
                    }
                }
            }
        }

//        if let config = object["config"] as? String {
//            competence.config = config
//        }
        
        return competence
    }
}