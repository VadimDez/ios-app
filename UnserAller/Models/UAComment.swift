//
//  UAComment.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UAComment: UACellObject {
    var id: UInt!
    var user: UAUser!
    var language: String!
    var updated: NSDate!
    var isDeleted: Bool = false
    var isOwner: Bool = false
    
    
    func initCommentWithJSON(json: Dictionary<String, AnyObject>) -> UAComment {

        if let _user = json["user"] as? Dictionary<String, AnyObject> {
            let firstName = _user["firstname"] as! String
            let lastName = _user["lastname"] as! String
            let userId = UInt((_user["id"] as AnyObject!).integerValue)
            
            self.user = UAUser(id: userId, fullName: "\(firstName) \(lastName)")
            
            self.isOwner = (userId == UserShared.sharedInstance.id)
        }
        
        if let commentId = json["id"] as? UInt {
            self.id = commentId
        }
        
        // set content
        self.content = json["content"] as! String

        // set lang
        self.language = json["language"] as! String

        // set updated
        if let _updated = json["updated"] as? String {
            self.updated = _updated.getDateFromLongString()
        }
        
        if let _deleted = json["deleted"] as? String {
            self.isDeleted = true
//            self.deleted = _deleted.getDateFromLongString()
        }
        
        // cell type
        self.cellType = "UACommentCell"
        
        // add media
        if let media = json["media"] as? [AnyObject] {
            self.addMediaToSuggestionWithJSON(media)
            if (self.media.count > 0) {
                self.cellType = "UACommentWithImageCell"
            }
        }

        return self
    }
    
    
    /**
    *  Get NSDate from string
    *
    */
    func getDateFromString(string: String) -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        return formatter.dateFromString(string)!
    }
}