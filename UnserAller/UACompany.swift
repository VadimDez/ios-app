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
    
    init () {
        self.id = 0
    }
    
    func setCompanyFromJSON(json: Dictionary<String, AnyObject>) {
        println(json)
        
        // set id
        self.id = json["id"] as UInt
        
        // set name
        self.name = json["name"] as String
        
        if let media = json["media"] as? [Dictionary<String, AnyObject>] {
            self.imageHash = self.getCompanyImageHash(media)
        }
    }
    
    /**
    Find and return company logo hash
    
    :param: media [Dictionary<String, AnyObject>]
    
    :returns: hash
    */
    func getCompanyImageHash(media: [Dictionary<String, AnyObject>]) -> String {
        if (media.count > 0) {
            for image in media {
                if ((image["category"] as String) == "companyLogo") {
                    return image["hash"] as String
                }
            }
        }
            
        return "new"
    }
}
