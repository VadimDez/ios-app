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
    var content: String!
    var updated: NSDate
    var deleted: NSDate
    var type: String
    var cellType: String
    var media: [AnyObject]
    
    init() {
        self.suggestionId = 0
        self.projectId = 0
        self.likeCount = 0
        self.commentCount = 0
        self.userId = 0
        self.userVotes = 0
        self.userName = ""
        self.projectName = ""
        self.content = ""
        self.updated = NSDate()
        self.deleted = NSDate()
        self.type = ""
        self.cellType = ""
        self.media = []
    }
    
    
    /**
     * Initialization of suggestion
     */
    func initSuggestion(jsonObject: AnyObject)-> UASuggestion {
        
        // set id
        if let suggestionId = jsonObject.objectForKey("suggestion")?.objectForKey("id") as? UInt {
            self.suggestionId = suggestionId
        }
        
        // set content
//        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if let content = jsonObject.objectForKey("content") as? NSString {
            self.content = content
        }

        // set project id
        if let projectId = jsonObject.objectForKey("project") as? UInt {
            self.projectId = projectId
        }

        // set like count
        if let likeCount = jsonObject.objectForKey("suggestion")?.objectForKey("like") as? Int {
            self.likeCount = likeCount
        }

        // set comment count
        if let commentCount = jsonObject.objectForKey("suggestion")?.objectForKey("comment") as? UInt {
            self.commentCount = commentCount
        }
        
        // set updated
        if let updated = jsonObject.objectForKey("suggestion")?.objectForKey("date")?.objectForKey("date") as? NSString {
            self.updated = self.getDateFromString(updated)
        }
        
        // set user id
        if let userId = jsonObject.objectForKey("user")?.objectForKey("id") as? UInt {
            self.userId = userId
        }

        // set user name
        if let userName = jsonObject.objectForKey("user")?.objectForKey("name") as? NSString {
            self.userName = userName
        }

        // set user votes
        if let userVotes = jsonObject.objectForKey("suggestion")?.objectForKey("userVote") as? Int {
            self.userVotes = userVotes
        }

        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName
        }

        // set type
        if let type = jsonObject.objectForKey("type") as? NSString {
            self.type = type
        }
        
        // set cell class type
        self.cellType = "SuggestionCell";
        
        return self
    }
    
    func initVote(jsonObject: AnyObject) -> UASuggestion {
        
        // set id
        if let suggestionId = jsonObject.objectForKey("suggestion")?.objectForKey("id") as? UInt {
            self.suggestionId = suggestionId
        }
        
        // set content
        //        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if let content = jsonObject.objectForKey("content") as? NSString {
            self.content = content
        }
        
        // set like count
        if let likeCount = jsonObject.objectForKey("suggestion")?.objectForKey("userVote") as? Int {
            self.likeCount = likeCount
        }
        
        // set comment count
        if let commentCount = jsonObject.objectForKey("suggestion")?.objectForKey("comment") as? UInt {
            self.commentCount = commentCount
        }
        
        // set updated
        if let updated = jsonObject.objectForKey("suggestion")?.objectForKey("date")?.objectForKey("date") as? NSString {
            self.updated = self.getDateFromString(updated)
        }
        
        // set user id
        if let userId = jsonObject.objectForKey("user")?.objectForKey("id") as? UInt {
            self.userId = userId
        }
        
        // set user name
        if let userName = jsonObject.objectForKey("user")?.objectForKey("name") as? NSString {
            self.userName = userName
        }
        
        // set user votes
        if let userVotes = jsonObject.objectForKey("suggestion")?.objectForKey("liked") as? Int {
            self.userVotes = userVotes
        }
        
        // set project id
        if let projectId = jsonObject.objectForKey("project") as? UInt {
            self.projectId = projectId
        }
        
        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName
        }
        
        // set type
        if let type = jsonObject.objectForKey("type") as? NSString {
            self.type = type
        }
        
        // set cell class type
        self.cellType = "VoteSuggestionCell";
        
        return self
    }
    
    func initNews(jsonObject: AnyObject) -> UASuggestion {
        
        // set content
        //        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if let content = jsonObject.objectForKey("content") as? NSString {
            self.content = content
        }
        
        // set project id
//        if let projectId = jsonObject.objectForKey("project") as? NSNumber {
//            self.projectId = projectId
//        }
        
        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName
        }

        // set cell class type
        self.cellType = "NewsCell";
        
        return self
    }
    
    func initNewsIncludeImages(jsonObject: AnyObject) -> UASuggestion {
        
        // set content
        //        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if let content = jsonObject.objectForKey("content") as? NSString {
            self.content = content
        }
        
        // set project id
        if let projectId = jsonObject.objectForKey("project") as? UInt {
            self.projectId = projectId
        }
        
        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName
        }
        
        // set type
        if let type = jsonObject.objectForKey("type") as? NSString {
            self.type = type
        }
        
        // set cell class type
        self.cellType = "NewsContainerTableCell";
        
        // add media
        if let media = jsonObject.objectForKey("media") as? [AnyObject] {
            self.addMediaToSuggestionWithJSON(media)
        }
        
        return self
    }
    
    func initSuggestIncludingImages(jsonObject: AnyObject) -> UASuggestion {
        
        // set id
        if let suggestionId = jsonObject.objectForKey("suggestion")?.objectForKey("id") as? UInt {
            self.suggestionId = suggestionId
        }
        
        // set content
        //        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if let content = jsonObject.objectForKey("content") as? NSString {
            self.content = content
        }
        
        // set project id
        if let projectId = jsonObject.objectForKey("project") as? UInt {
            self.projectId = projectId
        }
        
        // set like count
        if let likeCount = jsonObject.objectForKey("suggestion")?.objectForKey("like") as? Int {
            self.likeCount = likeCount
        }
        
        // set comment count
        if let commentCount = jsonObject.objectForKey("suggestion")?.objectForKey("comment") as? UInt {
            self.commentCount = commentCount
        }
        
        // set updated
        if let updated = jsonObject.objectForKey("suggestion")?.objectForKey("date")?.objectForKey("date") as? NSString {
            self.updated = self.getDateFromString(updated)
        }
        
        // set user id
        if let userId = jsonObject.objectForKey("user")?.objectForKey("id") as? UInt {
            self.userId = userId
        }
        
        // set user name
        if let userName = jsonObject.objectForKey("user")?.objectForKey("name") as? NSString {
            self.userName = userName
        }
        
        // set user votes
        if let userVotes = jsonObject.objectForKey("suggestion")?.objectForKey("userVote") as? Int {
            self.userVotes = userVotes
        }
        
        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName
        }
        
        // set type
        if let type = jsonObject.objectForKey("type") as? NSString {
            self.type = type
        }
        
        // set cell class type
        self.cellType = "ContainerTableCell";
        
        // set type
        self.type = "suggestion";
        
        // add media
        if let media = jsonObject.objectForKey("media") as? [AnyObject] {
            self.addMediaToSuggestionWithJSON(media)
        }
        
        return self
    }
    
    func initVoteIncludingImages(jsonObject: AnyObject) -> UASuggestion {
        
        // set id
        if let suggestionId = jsonObject.objectForKey("suggestion")?.objectForKey("id") as? UInt {
            self.suggestionId = suggestionId
        }
        
        // set content
        //        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if let content = jsonObject.objectForKey("content") as? NSString {
            self.content = content
        }
        
        // set project id
        if let projectId = jsonObject.objectForKey("project") as? UInt {
            self.projectId = projectId
        }
        
        // set like count
        if let likeCount = jsonObject.objectForKey("suggestion")?.objectForKey("like") as? Int {
            self.likeCount = likeCount
        }
        
        // set comment count
        if let commentCount = jsonObject.objectForKey("suggestion")?.objectForKey("comment") as? UInt {
            self.commentCount = commentCount
        }
        
        // set updated
        if let updated = jsonObject.objectForKey("suggestion")?.objectForKey("date")?.objectForKey("date") as? NSString {
            self.updated = self.getDateFromString(updated)
        }
        
        // set user id
        if let userId = jsonObject.objectForKey("user")?.objectForKey("id") as? UInt {
            self.userId = userId
        }
        
        // set user name
        if let userName = jsonObject.objectForKey("user")?.objectForKey("name") as? NSString {
            self.userName = userName
        }
        
        // set user votes
        if let userVotes = jsonObject.objectForKey("suggestion")?.objectForKey("userVote") as? Int {
            self.userVotes = userVotes
        }
        
        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName
        }
        
        // set type
        if let type = jsonObject.objectForKey("type") as? NSString {
            self.type = type
        }
        
        // set cell class type
        self.cellType = "VoteSuggestionTableCell";
        
        // add media
        if let media = jsonObject.objectForKey("media") as? [AnyObject] {
            self.addMediaToSuggestionWithJSON(media)
        }
        
        return self
    }
    
    /**
    *  Get NSDate from string
    *
    */
    func getDateFromString(string: String) -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.dateFromString(string)!
    }
    
    /**
    *  Add media object in media array
    */
    func addMediaToSuggestionWithJSON(json: [AnyObject]) {
        self.media = []
        
        for object in json {
            var mediaObject: UAMedia = UAMedia()
    
            // set height
            if let height = object.objectForKey("height") as? UInt {
                mediaObject.height = height
            }
            
            if let width = object.objectForKey("width") as? UInt {
                mediaObject.width = width
            }
            
            if let hash = object.objectForKey("hash") as? NSString {
                mediaObject.hash = hash
            }
    
            // add
            self.media.append(mediaObject);
        }
    }
    
    func initSuggestForActivity(jsonObject: AnyObject) -> UASuggestion {
        // set user name
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String, AnyObject> {
            // set suggestion id
            self.suggestionId = suggestion["id"] as UInt
            
            // set user name
            if let user = suggestion["user"] as? Dictionary<String,String> {
                let firstname = user["firstname"]
                let lastname = user["lastname"]
                
                self.userName = "\(firstname) \(lastname)"
            }
            
            // set project name
            self.projectName = suggestion["phase"]?.objectForKey("project")?.objectForKey("name") as String
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set content
            self.content = suggestion["suggestion"]?.objectForKey("content") as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
            
        }
        // set comment count
        self.commentCount = jsonObject.objectForKey("comments") as UInt
        
        // set like count
        self.likeCount = jsonObject.objectForKey("votes") as Int
        
        
        
        // set cell type
        self.cellType = "SuggestionCell"

        return self
    }
    
    /**
    *  Get value from string
    *  in case it's null instead 0
    */
    func getValueFromString(string: String) -> String {
        if (string.isEmpty) {
            return "0"
        }
        return string
        //return [NSString stringWithFormat:@"%@", ([string isKindOfClass:[NSNull class]]) ? @"0" : string];
    }
}