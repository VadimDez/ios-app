//
//  StringExtensions.swift
//  UnserAller
//
//  Created by Vadim Dez on 31/05/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

extension String {
    /**
    *  Get NSDate from string
    *
    */
    func getDateFromString() -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "Europe/Berlin")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.dateFromString(self)!
    }
    
    /**
    *  Get NSDate from string
    *
    */
    func getDateFromLongString() -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return formatter.dateFromString(self)!
    }
}
