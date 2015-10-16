//
//  User.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Foundation
import Locksmith
import Alamofire
import CoreData


class UAUser {
    var id: UInt!
    var fullName: String!
    var profileImageURL: String!
    var profileImageView: UIImageView!
    
    // CoreData
    var managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    func initWithParams(id: UInt, usrFullname: String, usrProfileImageUrl: String, usrProfileImageView:UIImageView) {
        self.id = id
        self.fullName = usrFullname
        self.profileImageURL = usrProfileImageUrl
        self.profileImageView = usrProfileImageView
    }
    
    init() {
    
    }
    
    init(id: UInt, fullName: String) {
        self.id = id
        self.fullName = fullName
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
        let url: String = "\(APIURL)/api/mobile/auth/login"
        
        Alamofire.request(.GET, url, parameters: ["username": email, "password": password])
            .authenticate(user: email, password: password)
            .responseJSON { (_, _, result) in
                
                switch result {
                case .Success(let JSON):
                    
                    // check if no error and correct email and pass
                    if (JSON.objectForKey("auth")?.intValue != 200) {
                        error()
                    } else {
                        success()
                    }
                    
                case .Failure(_, _):
                    error()
                    
                }
                
        }
    }
    
    /**
    Save email and password to key chain
    
    :param: email    email string
    :param: password password string
    */
    func saveEmailAndPasswordToKeychain(email: String, password: String) {
        do {
            // delete old
            try Locksmith.deleteDataForUserAccount("UnserAllerUser", inService: "UnserAller")
            // save new
            try Locksmith.saveData(["UserAuthEmailToken": email, "UserAuthPasswordToken": password], forUserAccount: "UnserAllerUser", inService: "UnserAller")
        } catch _ {
            
        }
    }
    
    func encode(string: String) -> NSData {
        let utf8str: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) //NSDataBase64EncodingOptions.fromRaw(0)!)
        
        let data: NSData = NSData(base64EncodedString: base64Encoded as String, options: NSDataBase64DecodingOptions(rawValue: 0))!
        
        return data
    }
    
    func decode(data: NSData) -> String {
        return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
    }
    
//    func getImage(URLString: String, imageView: UIImageView) {
//        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: URLString)!)
//        let getImage: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                println("Error: \(error.localizedDescription)")
//            } else {
//                image = UIImage(data: data)
//                
//                // Store the image in to our cache
//                self.imageCache[urlString] = image
//                dispatch_async(dispatch_get_main_queue(), {
//                    imageView.image = image
//                })
//            }
//        })
//        getImage.resume()
//    }
    
    
    /**
    Log out user from app
    
    :param: success
    :param: failure
    */
    func logout(success: () -> Void, failure: () -> Void) {
        let url: String = "\(APIURL)/api/mobile/auth/logout"
        
        Alamofire.request(.GET, url, parameters: nil)
            .response { (request, response, _, error) in
                if (error != nil) {
                    failure()
                } else {
                    do {
                        try Locksmith.deleteDataForUserAccount("UnserAllerUser", inService: "UnserAller")
                    } catch _ {
                        
                    }
                    success()
                }
                
        }
    }
    
    /**
    *  Get user from api
    */
    func getFromAPI(success: (user: User, credits: Dictionary<String, AnyObject>) -> Void) {
        let url: String = "\(APIURL)/api/mobile/profile/getuserinfo"
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { ( request, response, result) in
                
                switch result {
                case .Success(let JSON):
                    var mainUser: User!
                    var credits: Dictionary<String, AnyObject>!
                    
                    if let data = JSON.objectForKey("user") as? Dictionary<String, AnyObject> {
                        mainUser = self.getFromDB(data["id"] as! UInt)
                        
                        mainUser.id         = data["id"] as! Int
                        mainUser.firstname  = data["firstname"] as! String
                        mainUser.lastname   = data["lastname"] as! String
                        
                        self.save()
                        
                    }
                    
                    if let userCredits = JSON.objectForKey("credits") as? Dictionary<String, AnyObject> {
                        credits = userCredits
                    }
                    success(user: mainUser, credits: credits)
                    
                    
                case .Failure(_, let errors):
                    print(errors)
                }
        }
    }
    
    /**
    *  Get user from db
    */
    func getFromDB(id: UInt) -> User {
        
        // fetch request
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        // predicate
        let predicate = NSPredicate(format: "id == %i", id)
        
        // set predicate
        fetchRequest.predicate = predicate
        
        // perform fetch
        do {
            if let results = try self.managedContext.executeFetchRequest(fetchRequest) as? [User] {
                
                // create new
                if (results.count == 0) {
                    return NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedContext) as! User
                }
                
                return results[0]
            }
        } catch let error {
            print("Could not fetch \(error)")
        }
        
        return User()
    }
    
    /**
    *  Save
    */
    func save() {
        do {
            try self.managedContext.save()
        } catch let error {
            print("Could not save \(error)")
        }
    }
    
    /**
     *  Change password
     */
    func changePassword(actualPassword: String, newPassword: String, success: () -> Void, failure: () -> Void) -> Void {
        // save
        let url: String = "\(APIURL)/api/v1/user/resetpassword"
        
        Alamofire.request(.POST, url, parameters: ["oldpass": actualPassword, "password": newPassword])
            .response { (request, response, data, errors) -> Void in
                
                if(errors != nil || response?.statusCode >= 400) {
                    // print error
                    print(errors)
                    failure()
                } else {
                    success()
                }
        }
    }
    
    /**
     *  Update user's notifications
     */
    func updateNotifications(commentNotification: Int, projectInformation: Int, projectInvitation: Int, subscription: Int, notificationInterval: String, success: () -> Void, failure: () -> Void) -> Void {
        
        // save
        let url: String = "\(APIURL)/api/mobile/profile/updatenotifications"
        
        Alamofire.request(.POST, url, parameters: [
            "commentNotification":  commentNotification,
            "projectInformation":   projectInformation,
            "projectInvitation":    projectInvitation,
            "subscription":         subscription,
            "notificationInterval": notificationInterval
            ])
            .response { (request, response, data, errors) -> Void in
                
                if(errors != nil || response?.statusCode >= 400) {
                    // print error
                    print(errors)
                    failure()
                } else {
                    success()
                }
        }
    }
    
    func updateAddress(firstName: String, lastName: String, street: String, city: String, zipCode: String, address: String, gender: String, success: () -> Void, failure: () -> Void) -> Void {
        
        let url = "\(APIURL)/api/mobile/profile/saveuserpostalinfo"
        
        Alamofire.request(.POST, url, parameters: [
            "firstname":    firstName,
            "lastname":     lastName,
            "street":       street,
            "city":         city,
            "zipCode":      zipCode,
            "address":      address,
            "gender":       gender
            ])
            .response{ (request, response, data, errors) -> Void in
                
                if(errors != nil || response?.statusCode >= 400) {
                    // print error
                    print(errors)
                    failure()
                } else {
                    success()
                }
        }
    }
    
    func updateInfo(firstName: String, lastName: String, language: String, success: () -> Void, failure: () -> Void) -> Void {
        let url: String = "\(APIURL)/api/mobile/profile/saveuserinfo"
        
        Alamofire.request(.POST, url, parameters: ["firstname": firstName, "lastname": lastName, "language": language])
            .responseJSON { (_, _, result) -> Void in
                
                switch result {
                case .Success(let JSON):
                    if JSON.count != 0 {
                        success()
                    }
                    
                case .Failure(_, let errors):
                    // print error
                    print(errors)
                    failure()
                    
                }
        }
    }
    
    /**
    Get user settings
    
    :param: success function
    :param: failure function
    */
    func getSettings(success: (settings: Dictionary<String, AnyObject>) -> Void, failure: () -> Void) {
        let url: String = "\(APIURL)/api/mobile/profile/getsettings"
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { (_, _, result) -> Void in
                
                switch result {
                case .Success(let JSON):
                    if JSON.count != 0 {
                        success(settings: JSON  as! Dictionary<String, AnyObject>)
                    }
                case .Failure(_, let errors):
                    // print error
                    print(errors)
                    // error block
                    failure()
                }
        }
    }
}