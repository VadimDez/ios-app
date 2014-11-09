//
//  UAProjectViewModel.swift
//  UnserAller
//
//  Created by Vadim Dez on 09/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAProjectViewModel: NSObject {
    func getProjectsFromJSON(data: [Dictionary<String, AnyObject>]) -> [UAProject] {
        var projects: [UAProject] = []
        
        for object in data {
            var project: UAProject = UAProject()
            
            if let id = object["id"] as? Int {
                if let name = object["name"] as? String {
                    project.initWithParams(id, name: name)
                    projects.append(project)
                }
            }
        }
        
        return projects
    }
}
