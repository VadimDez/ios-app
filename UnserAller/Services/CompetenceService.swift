//
//  CompetenceService.swift
//  UnserAller
//
//  Created by Vadym on 13/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation
import Alamofire

class CompetenceService {
    
    func getCompetencesFromJSON(data: [Dictionary<String, AnyObject>]) -> [UACompetence] {
        var competences: [UACompetence] = []
        
        for object in data {
            competences.append(self.getCompetenceFromJSON(object))
        }
        
        return competences
    }
    
    func getCompetenceFromJSON(object: Dictionary<String, AnyObject>) -> UACompetence {
//        var competence: UACompetence = UACompetence()
//        
//        if let id = object["id"] as? UInt {
//            competence.id = id
//        }
//
//        if let name = object["name"] as? String {
//            competence.name = name
//        }
//        
//        if let content = object["content"] as? String {
//            competence.content = content
//        }
        
        if let format = object["format"] as? String {
            return self.getCompetenceByType(format, object: object)
            
            
//            if (format == "options" || format == "checkbox" || format == "likert") {
//                if let config = object["config"] as? Dictionary<String, AnyObject> {
//                    if let options = config["options"] as? [Dictionary<String, AnyObject>] {
//                        competence.options = options
//                    }
//                }
//            }
        }
//
//        if let config = object["config"] as? String {
//            competence.config = config
//        }
        
        return UACompetence()
    }
    
    
    func getOptions(array: [Dictionary<String, AnyObject>]) -> [UAOption] {
        var options: [UAOption] = []
        
        for option in array {
            options.append(UAOption(name: option["name"] as! String, value: option["value"] as! String))
        }
        
        return options
    }
    
    func getCompetenceByType(format: String, object: Dictionary<String, AnyObject>) -> UACompetence {
        switch format {
            case "placeholder": return self.getPlaceholderCompetence(object)
            case "input": return self.getSingleInputCompetence(object)
            case "textarea": return self.getMultipleLineInputCompetence(object)
            case "options": return self.getOptionsCompetence(object)
            case "checkbox": return self.getCheckboxCompetence(object)
            case "likert": return self.getLikertCompetence(object)
            default: return UACompetence()
        }
    }
    
    func getPlaceholderCompetence(object: Dictionary<String, AnyObject>) -> UAFreetextCompetence {
        var competence = UAFreetextCompetence()
        
        if let id = object["id"] as? UInt {
            competence.id = id
        }
        
        if let name = object["name"] as? String {
            competence.name = name
        }
        
        if let content = object["content"] as? String {
            competence.content = content
        }
        
        return competence
    }
    
    func getSingleInputCompetence(object: Dictionary<String, AnyObject>) -> UASingleInputCompetence {
        var competence = UASingleInputCompetence()
        
        if let id = object["id"] as? UInt {
            competence.id = id
        }
        
        if let name = object["name"] as? String {
            competence.name = name
        }
        
        if let content = object["content"] as? String {
            competence.content = content
        }
        
        return competence
    }
    
    func getMultipleLineInputCompetence(object: Dictionary<String, AnyObject>) -> UAMultilineInputCompetence {
        var competence = UAMultilineInputCompetence()
        
        if let id = object["id"] as? UInt {
            competence.id = id
        }
        
        if let name = object["name"] as? String {
            competence.name = name
        }
        
        if let content = object["content"] as? String {
            competence.content = content
        }
        
        return competence
    }
    
    func getOptionsCompetence(object: Dictionary<String, AnyObject>) -> UAOptionsCompetence {
        var competence = UAOptionsCompetence()
        
        if let id = object["id"] as? UInt {
            competence.id = id
        }
        
        if let name = object["name"] as? String {
            competence.name = name
        }
        
        if let content = object["content"] as? String {
            competence.content = content
        }
        
        if let config = object["config"] as? Dictionary<String, AnyObject> {
            if let options = config["options"] as? [Dictionary<String, AnyObject>] {
                competence.options = self.getOptions(options)
            }
        }
        
        return competence
    }
    
    func getCheckboxCompetence(object: Dictionary<String, AnyObject>) -> UACheckboxCompetence {
        var competence = UACheckboxCompetence()
        
        if let id = object["id"] as? UInt {
            competence.id = id
        }
        
        if let name = object["name"] as? String {
            competence.name = name
        }
        
        if let content = object["content"] as? String {
            competence.content = content
        }
        
        if let config = object["config"] as? Dictionary<String, AnyObject> {
            if let options = config["options"] as? [Dictionary<String, AnyObject>] {
                competence.options = self.getOptions(options)
            }
        }
        
        return competence
    }
    
    func getLikertCompetence(object: Dictionary<String, AnyObject>) -> UALikertCompetence {
        var competence = UALikertCompetence()
        
        if let id = object["id"] as? UInt {
            competence.id = id
        }
        
        if let name = object["name"] as? String {
            competence.name = name
        }
        
        if let content = object["content"] as? String {
            competence.content = content
        }
        
        if let config = object["config"] as? Dictionary<String, AnyObject> {
            if let options = config["options"] as? [Dictionary<String, AnyObject>] {
                competence.options = self.getOptions(options)
            }
        }
        
        return competence
    }
    
    
    func getEntries(project: UInt, projectStep: UInt, success: (competences: [Dictionary<String, AnyObject>]) -> Void, error: () -> Void) {
        var url = "\(APIURL)/api/mobile/competence/get"
        
        var params:[String: AnyObject] = [String: AnyObject]()
        
        if (project != 0) {
            params["project"] = project
        }
        if (projectStep != 0) {
            params["step"] = projectStep
        }
        
        Alamofire.request(.GET, url, parameters: params)
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    // error block
                    error()
                } else {
                    
                    success(competences: JSON?.objectForKey("competences") as! [Dictionary<String, AnyObject>])
                }
        }
    }
}