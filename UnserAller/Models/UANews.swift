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
    var projectId: UInt!
    var projectName: String = ""
    var title: String!
    var created: String!
    var updated: NSDate     = NSDate()
    
    override init() {
        super.init()
    }
    
    func initNewsForTimeline(jsonObject: AnyObject) -> UANews {
        
        if let pageArticle = jsonObject.objectForKey("pageArticle") as? Dictionary<String, AnyObject> {
            if let pageArticleId = pageArticle["id"] as? UInt {
                self.id = pageArticleId
            }
            
            if let created = pageArticle["created"] as? Dictionary<String, String> {
                let createdString: String = created["date"]!
                self.updated = createdString.getDateFromString()
            }
        }
        
        // set content
        //        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
//        var articleContent: String = ""
        
        if let title = jsonObject.objectForKey("title") as? String {
//            articleContent = title
            self.title = title.html2String()
        }
        
        if let content = jsonObject.objectForKey("content") as? NSString {
//            if (count(articleContent) > 0) {
//                articleContent = articleContent + " "
//            }
//            
//            articleContent = articleContent + (content as String)
            self.content = (content as String).html2String()
        }
        
//        self.content = articleContent
//        self.content = self.content.html2String()
        
        // set project id
        self.projectId = UInt((jsonObject.objectForKey("project") as AnyObject!).integerValue)
        
        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName as String
        }
        
        // set cell class type
        self.cellType = "NewsCell";
        
        return self
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
    
    func initNewsIncludeImages(jsonObject: AnyObject) -> UANews {
        
        // set content
        //        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if let content = jsonObject.objectForKey("content") as? NSString {
            self.content = content as String
            self.content = self.content.html2String()
        }
        
        // set project id
        self.projectId = UInt((jsonObject.objectForKey("project") as AnyObject!).integerValue)
        
        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName as String
        }
        
        // set cell class type
        self.cellType = "NewsContainerTableCell";
        
        // add media
        if let media = jsonObject.objectForKey("media") as? [AnyObject] {
            self.addMediaToSuggestionWithJSON(media)
        }
        
        return self
    }
}