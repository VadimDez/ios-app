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
        project.company = UACompany()
        
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
            project.company.name = company
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

            if let id = object["id"] as? UInt {
                phase.id = id
            }
            if let name = object["name"] as? String {
                println("name")
                phase.name = name
            }
            if let type = object["type"] as? String {
                phase.type = type
            }
            
            // if old phase - take phase type as name
            if (phase.name == nil) {
                if (phase.type != nil) {
                    phase.name = phase.type
                } else {
                    phase.name = ""
                }
            }
            
            phases.append(phase)
        }
        
        return phases
    }
    
    /**
    Get project object for project view controller
    
    :param: json - Json
    
    :returns: UAProject object
    */
    func getProjectForProject(json: Dictionary<String, AnyObject>) -> UAProject {
        var project = UAProject()
        
        // set id
        project.id = json["id"] as UInt
        
        // set name
        project.name = json["name"] as? String
        
        // set image hash
        if let img = json["image"] as? String {
            project.imageHash = img
        }
        
        // set bookmarked value
        project.bookmarked = ((json["bookmarked"] as? Int) == 1)
        
        // closed community
        project.closedCommunity = ((json["closedCommunity"] as? Int) == 1)
        
        // set company
        project.company = UACompany()
        if let company = json["company"] as? Dictionary<String, AnyObject> {
            project.company.id = company["id"] as UInt
            project.company.name = company["name"] as? String
        }
        
        return project
    }
}
