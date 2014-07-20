//
//  User.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class User {
    var userId: Int!
    var fullname: String!
    var profileImageURL: String!
    var profileImageView: UIImageView!
    
    func initWithParams(usrId: Int, usrFullname: String, usrProfileImageUrl: String, usrProfileImageView:UIImageView) {
        userId = usrId
        fullname = usrFullname
        profileImageURL = usrProfileImageUrl
        profileImageView = usrProfileImageView
    }
    
    init() {
        
    }
    
    func checkStringsWithString(value: String) -> Bool {
        if value == "" || value == " " {
            return false
        } else {
            return true
        }
    }
}