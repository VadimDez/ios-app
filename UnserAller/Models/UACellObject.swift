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
    
}