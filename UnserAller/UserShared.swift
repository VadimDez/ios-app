//
//  UserShared.swift
//  UnserAller
//
//  Created by Vadym on 28/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//


class UserShared {
    static let sharedInstance = UserShared()
    
    var id: UInt!
    
    
    private init() {
        
    }
    
    func setId(userId: UInt) {
        self.id = userId
    }
}