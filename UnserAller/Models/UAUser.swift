//
//  User.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class UAUser {
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
    
    /**
     * Check if string is empty
     */
    func checkStringsWithString(value: String) -> Bool {
        if value == "" || value == " " {
            return false
        } else {
            return true
        }
    }
    
    /**
     * Validate user email and password
     *
     */
    func getUserCrederntials(email: String, password: String, success: () -> Void, error: () -> Void ) {
        let url: String = "https://\(APIURL)/api/mobile/auth/login"
        
        Alamofire.request(.GET, url, parameters: ["username": email, "password": password])
            .authenticate(user: email, password: password)
            .responseJSON { (request, response, JSON, _error) in
                print(_error)
                // check if no error and correct email and pass
                if ((_error != nil) || JSON == nil || JSON?.objectForKey("auth")?.intValue != 200) {
                    error()
                } else {
                    success()
                }
                
        }
    }
    
    func saveEmailAndPasswordToKeychain(email: String, password: String) {
        Locksmith.saveData(["UserAuthEmailToken": email, "UserAuthPasswordToken": password], forKey: "UnserAllerAuthToken", inService: "UnserAller", forUserAccount: "UnserAllerUser");
//        Keychain.save("UserAuthUserToken", data: self.encode(email))
//        Keychain.save("UserAuthPasswordToken", data: self.encode(password))
    }
    
    func encode(string: String) -> NSData {
        let utf8str: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) //NSDataBase64EncodingOptions.fromRaw(0)!)
        
        let data: NSData = NSData(base64EncodedString: base64Encoded, options: NSDataBase64DecodingOptions(rawValue: 0))!
        
        return data
    }
    
    func decode(data: NSData) -> String {
        return NSString(data: data, encoding: NSUTF8StringEncoding)!
    }
}