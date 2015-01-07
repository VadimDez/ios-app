//
//  UANews.swift
//  UnserAller
//
//  Created by Vadim Dez on 06/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UANews: UACellObject {
    var id: UInt!
    var projectId: Int!
    var title: String!
    var created: String!
    
    override init() {
        super.init()
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
        
        // title
        if let newsTitle = object.objectForKey("title") as? String {
            self.title = newsTitle
        }
        
        // created
        if let newsCreated = object.objectForKey("created") as? String {
            self.created = newsCreated
        }
        
        // set cell type
        self.cellType = "UAProjectNewsCell"
        
        return self
    }
}