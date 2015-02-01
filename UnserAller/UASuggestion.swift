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
        self.projectId = UInt((jsonObject.objectForKey("project") as AnyObject!).integerValue)
        
        if let _suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String, AnyObject> {
            
        }

        // set like count
        if let likeCount = jsonObject.objectForKey("suggestion")?.objectForKey("liked") as? Int {
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
        
        if let suggestion = jsonObject.objectForKey("suggestion") as? Dictionary<String, AnyObject> {
            
            // set id
            if let suggestionId = suggestion["id"] as? UInt {
                self.suggestionId = suggestionId
            }
            
            
            // set comment count
            if let _commentCount = suggestion["comment"] as? UInt {
                self.commentCount = _commentCount
            }
            
            // set like count
            if let _userVotes = suggestion["userVote"] as? Int {
                self.userVotes = _userVotes
            }
            
            // set updated
            if let updated = suggestion["date"]?.objectForKey("date") as? NSString {
                self.updated = self.getDateFromString(updated)
            }
            
            // set user votes
            if (!(suggestion["like"] is NSNull)) {
                if let likes:AnyObject = suggestion["like"] {
                    self.likeCount = likes.integerValue
                }
            }
        }
        
        // set content
        //        self.content = [[[object objectForKey:@"content"] stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if let content = jsonObject.objectForKey("content") as? NSString {
            self.content = content
        }
        
        // set user id
        if let userId = jsonObject.objectForKey("user")?.objectForKey("id") as? UInt {
            self.userId = userId
        }
        
        // set user name
        if let userName = jsonObject.objectForKey("user")?.objectForKey("name") as? NSString {
            self.userName = userName
        }
        
        // set project id
        self.projectId = UInt((jsonObject.objectForKey("project") as AnyObject!).integerValue)
        
        // set project name
        if let projectName = jsonObject.objectForKey("projectName") as? NSString {
            self.projectName = projectName
        }
        
        // set type
        if let type = jsonObject.objectForKey("type") as? NSString {
            self.type = type
        }
        
        // set cell class type
        self.cellType = "UASuggestionVoteCell";
        
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
        self.projectId = UInt((jsonObject.objectForKey("project") as AnyObject!).integerValue)
        
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
        self.projectId = UInt((jsonObject.objectForKey("project") as AnyObject!).integerValue)
        
        // set like count
        if let likeCount = jsonObject.objectForKey("suggestion")?.objectForKey("liked") as? Int {
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
        self.cellType = "UASuggestImageCell";
        
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
        self.projectId = UInt((jsonObject.objectForKey("project") as AnyObject!).integerValue)
        
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
        self.cellType = "UASuggestionVoteImageCell";
        
        // add media
        if let media = jsonObject.objectForKey("media") as? [AnyObject] {
            self.addMediaToSuggestionWithJSON(media)
        }
        
        return self
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
            self.projectId = UInt((suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as AnyObject!).integerValue)
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
            
        }
        
        // set comment count
        if (!(jsonObject.objectForKey("comments") is NSNull)) {
            if let _commentCount: AnyObject = jsonObject.objectForKey("comments") {
                self.commentCount = UInt(_commentCount.integerValue)
            }
        }
        
        // set like count
        if (!(jsonObject.objectForKey("votes") is NSNull)) {
            if let _likeCount: AnyObject = jsonObject.objectForKey("votes") {
                self.likeCount = _likeCount.integerValue
            }
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
            self.projectId = UInt((suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as AnyObject!).integerValue)
            
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
        if (!(jsonObject.objectForKey("votes") is NSNull)) {
            if let _likeCount: AnyObject = jsonObject.objectForKey("votes") {
                self.likeCount = _likeCount.integerValue
            }
        }
        
        // set cell type
        self.cellType = "UASuggestionVoteCell";
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
            self.projectId = UInt((suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as AnyObject!).integerValue)
            
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
        if (!(jsonObject.objectForKey("comments") is NSNull)) {
            if let _commentCount: AnyObject = jsonObject.objectForKey("comments") {
                self.commentCount = UInt(_commentCount.integerValue)
            }
        }
        
        // set like count
        if (!(jsonObject.objectForKey("votes") is NSNull)) {
            if let _likeCount: AnyObject = jsonObject.objectForKey("votes") {
                self.likeCount = _likeCount.integerValue
            }
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
            self.projectId = UInt((suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as AnyObject!).integerValue)
            
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
        self.cellType = "UASuggestionVoteImageCell";
        
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
            self.projectId = UInt((suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as AnyObject!).integerValue)
            
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
            if let lastname = suggestion["user"]?.objectForKey("lastname") as? String {
                self.userName = " \(lastname)"
            }
            
            // set user id
            self.userId = suggestion["user"]?.objectForKey("id") as UInt
            
            // set project id
            self.projectId = UInt((suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as AnyObject!).integerValue)
            
            // set content
            self.content = suggestion["content"] as String
            
            // set updated
            self.updated = self.getDateFromString(suggestion["created"]?.objectForKey("date") as String)
        }

        // set user votes
        if (!(jsonObject.objectForKey("userVotes") is NSNull)) {
            if let votes: AnyObject = jsonObject.objectForKey("userVotes") {
                self.userVotes = votes.integerValue
            }
        }

        // set comment count
        if let _commentCount: AnyObject = jsonObject.objectForKey("comments") {
            self.commentCount = UInt(_commentCount.integerValue)
        }
        // set like count
        if (!(jsonObject.objectForKey("votes") is NSNull)) {
            if let _likeCount: AnyObject = jsonObject.objectForKey("votes") {
                self.likeCount = _likeCount.integerValue
            }
        }
        
        // set cell type
        self.cellType = "UASuggestionVoteCell";
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
            self.projectId = UInt((suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as AnyObject!).integerValue)
            
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
            self.projectId = UInt((suggestion["phase"]?.objectForKey("project")?.objectForKey("id") as AnyObject!).integerValue)
            
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
        self.cellType = "UASuggestionVoteImageCell";
        
        return self
    }
    
    
    // MARK: SuggestionViewController
    func getSuggestionFromJSONForSuggestionVC(json: Dictionary<String, AnyObject>) -> UASuggestion {
        
        if let _suggestion = json["0"] as? Dictionary<String, AnyObject> {
            
            if let _user = _suggestion["user"] as? Dictionary<String, AnyObject> {
                // user id
                self.userId = _user["id"] as UInt
                
                self.userName = (_user["firstname"] as String) + " " + (_user["lastname"] as String)
            }
            
            self.content = _suggestion["content"] as String
            
            if let _media = _suggestion["mediaSuggestion"] as? [Dictionary<String, String>] {
                self.addMediaToSuggestionWithJSON(_media)
            }
            
            if let _created = _suggestion["created"] as? Dictionary<String, String> {
                self.updated = self.getDateFromString(_created["date"]!)
            }
        }
        
        // set project id
//        if (!(json["project"] is NSNull)) {
//            if let _projectId = json["project"] as? UInt {
//                self.projectId = _projectId
//            }
//        }
        
        // set project name
//        self.projectName = json["projectName"] as String
        
        self.type = json["suggestionType"] as String
        
        if (!(json["votes"] is NSNull)) {
            if let _votes: Int = json["votes"] as? Int {
                self.likeCount = _votes
            }
        }
        
        if (!(json["userVotes"] is NSNull)) {
            if let _userVotes: Int = json["userVotes"] as? Int {
                self.likeCount = _userVotes
            }
        }
        
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