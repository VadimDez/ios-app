//
//  UACellObject.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UACellObject {
    
    var cellType: String
    var content: String
    var media: [UAMedia]
    
    init() {
        self.cellType   = ""
        self.content    = ""
        self.media      = []
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
    *  Get NSDate from string
    *
    */
    func getDateFromLongString(string: String) -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
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
                mediaObject.hash = hash as String
            }
            
            // add
            self.media.append(mediaObject);
        }
    }
}