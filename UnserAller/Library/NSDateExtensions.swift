//
//  NSDateExtensions.swift
//  UnserAller
//
//  Created by Vadim Dez on 31/05/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

extension NSDate {
    func getStringFromDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        return dateFormatter.stringFromDate(self)
    }
}
