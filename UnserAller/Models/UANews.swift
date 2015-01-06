//
//  UANews.swift
//  UnserAller
//
//  Created by Vadim Dez on 06/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UANews {
    var id: UInt!
    var content: String!
    var projectId: Int!
    var projectName: String!
    var created: NSDate!
    var media: [UAMedia]
    var cellType: String!
    
    init() {
        media = []
    }
    
    func initNewsForProjectWithObject(object: AnyObject) -> UANews {
        // set id
        if let newsId = object.objectForKey("id") as? UInt {
            self.id = newsId
        }
        // set content
        if let newsContent = object.objectForKey("content") as? String {
            self.content = newsContent
        }
        // set cell type
        self.cellType = "UAProjectNewsCell"
        
        return self
    }
}