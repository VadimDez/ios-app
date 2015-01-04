//
//  UAProjectViewModel.swift
//  UnserAller
//
//  Created by Vadim Dez on 09/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAProjectViewModel: NSObject {
    /**
     *  Make a Project array from json
     */
    func getProjectsFromJSON(data: [Dictionary<String, AnyObject>]) -> [UAProject] {
        var projects: [UAProject] = []
        
        for object in data {
            var project: UAProject = UAProject()
            
            // check if has id
            if let id = object["id"] as? UInt {
                // check if has a name
                if let name = object["name"] as? String {
                    // set params
                    project.initWithParams(id, name: name)
                    
                    // add project to project list
                    projects.append(project)
                }
            }
        }
        
        return projects
    }
    
    /**
     *  Make a Project-Bookmarks array from JSON
     */
    func getBookmarksFromJSON(data: [Dictionary<String, AnyObject>]) -> [UAProject] {
        var projects: [UAProject] = []
        
        for object in data {
            projects.append(self.projectFromJSON(object))
        }
        
        return projects
    }
    
    func projectFromJSON(object:Dictionary<String, AnyObject>) -> UAProject {
        var project = UAProject()
        
        if let id = object["id"] as? UInt {
            project.id = id
        }
        if let name = object["name"] as? String {
            project.name = name
        }
        if let title = object["title"] as? String {
            project.title = title
        }
        if let company = object["company"] as? String {
            project.company = company
        }
        
        return project
    }
    
    /**
     *  Get object phases array from json
     */
    func getPhasesFromJSON(json: [Dictionary<String, AnyObject>]) -> [UAPhase] {
        var phases: [UAPhase] = []
        
        for object in json {
            var phase: UAPhase = UAPhase()
            println(object)
            if let id = object["id"] as? UInt {
                phase.id = id
            }
            if let name = object["name"] as? String {
                phase.name = name
            }
            if let type = object["type"] as? String {
                phase.type = type
            }
            
            phases.append(phase)
        }
        
        return phases
    }
}
