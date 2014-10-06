//
//  UASuggestion.swift
//  UnserAller
//
//  Created by Vadym on 06/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UASuggestion {
    
    // attributes
    var suggestionId: UInt
    var projectId: UInt
    var likeCount: Int
    var commentCount: UInt
    var userId: UInt
    var userVotes: Int
    var userName: String
    var projectName: String
    var content: String
    var updated: NSDate
    var deleted: NSDate
    var type: String
    var cellType: String
    var media: [AnyObject]
    
    
    func initSuggestion(jsonObject: AnyObject)-> UASuggestion {
        println("test")
        
        return self
    }
}