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
    
    
    func initCommentWithJSON(json: Dictionary<String, AnyObject>) -> UAComment {

        if let _user = json["user"] as? Dictionary<String, AnyObject> {
            let firstName = _user["firstname"] as! String
            let lastName = _user["lastname"] as! String
            
            self.user = UAUser(id: UInt((_user["id"] as AnyObject!).integerValue), fullName: "\(firstName) \(lastName)")
        }
        
        // set content
        self.content = json["content"] as! String

        // set lang
        self.language = json["language"] as! String

        // set updated
        if let _updated = json["updated"] as? NSString {
            self.updated = self.getDateFromString("2014-11-22T09:49:56+01:00")
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
    override func getDateFromString(string: String) -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        return formatter.dateFromString(string)!
    }
}