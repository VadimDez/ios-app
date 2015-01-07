//
//  UASuggestion.swift
//  UnserAller
//
//  Created by Vadym on 06/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UASuggestion: UACellObject {
    
    // attributes
    var suggestionId: UInt  = 0
    var projectId: UInt     = 0
    var likeCount: Int      = 0
    var commentCount: UInt  = 0
    var userId: UInt        = 0
    var userVotes: Int      = 0
    var userName: String    = ""
    var projectName: String = ""
    var updated: NSDate     = NSDate()
    var deleted: NSDate     = NSDate()
    var type: String        = ""
    
    override init() {
        super.init()
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
        self.cellType = "SuggestImageCell";
        
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
            if let firstname = suggestion["user"]?.objectForKey("firstname") as? String {
                self.userName += firstname
            }
            if let lastname = suggestion["user"]?.objectForKey("lastname") as? String {
                self.userName += " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project name
            self.projectName = suggestion["phase"]?.objectForKey("project")?.objectForKey("name") as String
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
            
        }
        // set comment count
        if let commentCount = jsonObject.objectForKey("comments") as? UInt {
            self.commentCount = commentCount
        }
        
        // set like count
        if let votes = jsonObject.objectForKey("votes") as? Int {
            self.likeCount = votes
        }
        
        // set cell type
        self.cellType = "SuggestionCell"

        return self
    }
    
    func initVoteForActivity(jsonObject: AnyObject) -> UASuggestion {
        
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String,AnyObject> {
            
            // set suggestion id
            self.suggestionId = suggestion["id"] as UInt
            
            // set user name
            if let firstname = suggestion["user"]?.objectForKey("firstname") as? String {
                self.userName = firstname
            }
            if let lastname = suggestion["iser"]?.objectForKey("lastname") as? String {
                self.userName = " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set project name
            self.projectName = suggestion["phase"]?.objectForKey("project")?.objectForKey("name") as String
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
        }
        
        // set user votes
        if let userVotes = jsonObject.objectForKey("userVotes") as? Int {
            self.userVotes = userVotes
        }
        
        // set comment count
        if let commentCount = jsonObject.objectForKey("comments") as? UInt {
            self.commentCount = commentCount
        }
        // set like count
        if let likeCount = jsonObject.objectForKey("votes") as? Int {
            self.likeCount = likeCount
        }
        
        // set cell type
        self.cellType = "VoteSuggestionCell";
        return self
    }
    
    func initSuggestIncludeImagesForActivity(jsonObject: AnyObject) -> UASuggestion {
        
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String, AnyObject> {
            
            // set suggestion id
            self.suggestionId = suggestion["id"] as UInt
            // set user name
            if let firstname = suggestion["user"]?.objectForKey("firstname") as? String {
                self.userName = firstname
            }
            if let lastname = suggestion["iser"]?.objectForKey("lastname") as? String {
                self.userName = " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set project name
            self.projectName = suggestion["phase"]?.objectForKey("project")?.objectForKey("name") as String
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)

            // add media
            if let media = suggestion["mediaSuggestion"] as? [AnyObject] {
                self.addMediaToSuggestionWithJSON(media)
            }
        }
        // set comment count
        if let commentCount = jsonObject.objectForKey("comments") as? UInt {
            self.commentCount = commentCount
        }
        // set like count
        if let likeCount = jsonObject.objectForKey("votes") as? Int {
            self.likeCount = likeCount
        }
        
        
        // set type
        self.type = "suggestionMedia";
        
        // set cell type
        self.cellType = "UASuggestImageCell";

        return self
    }
    
    func initVoteIncludeImagesForActivity(jsonObject: AnyObject) -> UASuggestion {
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String, AnyObject> {
            
            // set suggestion id
            self.suggestionId = suggestion["id"] as UInt
            // set user name
            if let firstname = suggestion["user"]?.objectForKey("firstname") as? String {
                self.userName = firstname
            }
            if let lastname = suggestion["iser"]?.objectForKey("lastname") as? String {
                self.userName = " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set project name
            self.projectName = suggestion["phase"]?.objectForKey("project")?.objectForKey("name") as String
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
            
            // add media
            if let media = suggestion["mediaSuggestion"] as? [AnyObject] {
                self.addMediaToSuggestionWithJSON(media)
            }
        }
        // set comment count
        if let commentCount = jsonObject.objectForKey("comments") as? UInt {
            self.commentCount = commentCount
        }
        // set like count
        if let likeCount = jsonObject.objectForKey("votes") as? Int {
            self.likeCount = likeCount
        }
        // set user votes
        if let userVotes = jsonObject.objectForKey("userVotes") as? Int {
            self.userVotes = userVotes
        }
        // set type
        self.type = "project";
        
        // set cell class type
        self.cellType = "VoteSuggestionTableCell";
        
        return self
    }
    
    // project
    func initNewsForProjectWithObject(jsonObject: AnyObject) -> UASuggestion {
        // project name
        if let title = jsonObject.objectForKey("title") as? String {
            self.projectName = title
        }
        // created
        if let created = jsonObject.objectForKey("created") as? String {
            self.updated = self.getDateFromString(created)
        }
        // content
        if let content = jsonObject.objectForKey("content") as? String {
            self.content = content
        }
        
        self.cellType = "NewsCell"
        
        return self
    }
    func initSuggestForProjectWithObject(jsonObject: AnyObject) -> UASuggestion {
        // set user name
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String, AnyObject> {
            // set suggestion id
            self.suggestionId = suggestion["id"] as UInt
            
            // set user name
            if let firstname = suggestion["user"]?.objectForKey("firstname") as? String {
                self.userName += firstname
            }
            if let lastname = suggestion["user"]?.objectForKey("lastname") as? String {
                self.userName += " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
            
        }
        // set comment count
        if let commentCount = jsonObject.objectForKey("comments") as? UInt {
            self.commentCount = commentCount
        }
        
        // set like count
        if let votes = jsonObject.objectForKey("votes") as? Int {
            self.likeCount = votes
        }
        
        // set cell type
        self.cellType = "SuggestionCell"
        
        return self
    }
    
    func initVoteForProjectWithObject(jsonObject: AnyObject) -> UASuggestion {
        
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String,AnyObject> {
            
            // set suggestion id
            self.suggestionId = suggestion["id"] as UInt
            
            // set user name
            if let firstname = suggestion["user"]?.objectForKey("firstname") as? String {
                self.userName = firstname
            }
            if let lastname = suggestion["iser"]?.objectForKey("lastname") as? String {
                self.userName = " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
        }
        
        // set user votes
        if let userVotes = jsonObject.objectForKey("userVotes") as? Int {
            self.userVotes = userVotes
        }
        
        // set comment count
        if let commentCount = jsonObject.objectForKey("comments") as? UInt {
            self.commentCount = commentCount
        }
        // set like count
        if let likeCount = jsonObject.objectForKey("votes") as? Int {
            self.likeCount = likeCount
        }
        
        // set cell type
        self.cellType = "VoteSuggestionCell";
        return self
    }
    func initSuggestIncludeImagesForProjectWithObject(jsonObject: AnyObject) -> UASuggestion {
        
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String, AnyObject> {
            
            // set suggestion id
            self.suggestionId = suggestion["id"] as UInt
            // set user name
            if let firstname = suggestion["user"]?.objectForKey("firstname") as? String {
                self.userName = firstname
            }
            if let lastname = suggestion["iser"]?.objectForKey("lastname") as? String {
                self.userName = " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
            
            // add media
            if let media = suggestion["mediaSuggestion"] as? [AnyObject] {
                self.addMediaToSuggestionWithJSON(media)
            }
        }
        // set comment count
        if let commentCount = jsonObject.objectForKey("comments") as? UInt {
            self.commentCount = commentCount
        }
        // set like count
        if let likeCount = jsonObject.objectForKey("votes") as? Int {
            self.likeCount = likeCount
        }
        
        
        // set type
        self.type = "suggestionMedia";
        
        // set cell type
        self.cellType = "UASuggestImageCell";
        
        return self
    }
    func initVoteIncludeImagesForProjectWithObject(jsonObject: AnyObject) -> UASuggestion {
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String, AnyObject> {
            
            // set suggestion id
            self.suggestionId = suggestion["id"] as UInt
            // set user name
            if let firstname = suggestion["user"]?.objectForKey("firstname") as? String {
                self.userName = firstname
            }
            if let lastname = suggestion["iser"]?.objectForKey("lastname") as? String {
                self.userName = " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project id
            self.projectId = suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as UInt
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
            
            // add media
            if let media = suggestion["mediaSuggestion"] as? [AnyObject] {
                self.addMediaToSuggestionWithJSON(media)
            }
        }
        // set comment count
        if let commentCount = jsonObject.objectForKey("comments") as? UInt {
            self.commentCount = commentCount
        }
        // set like count
        if let likeCount = jsonObject.objectForKey("votes") as? Int {
            self.likeCount = likeCount
        }
        // set user votes
        if let userVotes = jsonObject.objectForKey("userVotes") as? Int {
            self.userVotes = userVotes
        }
        // set type
        self.type = "project";
        
        // set cell class type
        self.cellType = "VoteSuggestionTableCell";
        
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