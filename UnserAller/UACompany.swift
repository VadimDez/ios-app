//
//  UACompany.swift
//  UnserAller
//
//  Created by Vadim Dez on 16/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UACompany {
    var id: UInt
    var name: String!
    var description: String!
    var imageHash: String = "new"
    var projects: [UAProject] = []
    
    init () {
        self.id = 0
    }

    init(id: UInt, name: String) {
        self.id = id
        self.name = name
    }
    
    func setCompanyFromJSON(json: Dictionary<String, AnyObject>) {
//        println(json)
        
        // set id
        self.id = json["id"] as! UInt
        
        // set name
        self.name = json["name"] as! String
        
        if let media = json["media"] as? [Dictionary<String, AnyObject>] {
            self.imageHash = self.getCompanyImageHash(media)
        }

        // add projects
        if (!(json["project"] is NSNull)) {
            self.addProjects(json["project"] as! NSDictionary)
        }
    }
    
    /**
    Add project objects
    
    - parameter json: - JSON
    */
    func addProjects(json: NSDictionary) {

        for (_,object) in json {
            let project = UAProject()

            // id
            project.id = object["id"] as! UInt

            // name
            project.name = object["name"] as! String
            
            // title
            project.title = object["title"] as! String
            
            // closed community
            project.closedCommunity = ((object["closedCommunity"] as! Int) == 1)

            // set company
            project.company = UACompany(id: self.id, name: self.name)

            // set media
            project.imageUrl = "\(APIURL)/api/v1/media/project/\(project.id)"

            self.projects.append(project)
        }
    }
    
    /**
    Find and return company logo hash
    
    - parameter media: [Dictionary<String, AnyObject>]
    
    - returns: hash
    */
    func getCompanyImageHash(media: [Dictionary<String, AnyObject>]) -> String {
        if (media.count > 0) {
            for image in media {
                if ((image["category"] as! String) == "companyLogo") {
                    return image["hash"] as! String
                }
            }
        }
            
        return "new"
    }
}
