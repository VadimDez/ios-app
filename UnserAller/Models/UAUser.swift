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
import CoreData

class UAUser {
    var id: UInt!
    var fullName: String!
    var profileImageURL: String!
    var profileImageView: UIImageView!
    
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
        Locksmith.saveData(["UserAuthEmailToken": email, "UserAuthPasswordToken": password], forUserAccount: "UnserAllerUser", inService: "UnserAller")
//        Locksmith.saveData(["UserAuthEmailToken": email, "UserAuthPasswordToken": password], forKey: "UnserAllerAuthToken", inService: "UnserAller", forUserAccount: "UnserAllerUser");
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
    
    func getUserInfo(success: () -> Void) {
        let url: String = "https://\(APIURL)/api/v1/user"
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { ( request, response, JSON, error) in
                if (error != nil) {
                    // error handling
                } else {
                    self.saveUserInfo(JSON as Dictionary<String, AnyObject>, success: success)
                }
        }
    }
    
    func saveUserInfo(JSON: Dictionary<String, AnyObject>, success: () -> Void) {
//        println(JSON)
        if let data = JSON["user"] as? Dictionary<String, AnyObject> {
            var error: NSError?

            let managedContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            
            // fetch request
            let fetchRequest = NSFetchRequest(entityName: "User")
            
            // perform fetch
            if let results = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [User] {
                var mainUser: User?
                // create new
                if (results.count == 0) {
//                    mainUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedContext) as? User
                    let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
                    mainUser = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as? User
                } else {
                    println(results[0])
                    mainUser = results[0]
                }

                /*
                // save
                let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
                let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                */
                

                if let _lastName = JSON["id"] as? Int {
                    mainUser?.id = _lastName
                }
                
                if let _firstName = JSON["firstname"] as? String {
                    mainUser?.firstname = _firstName
                }
                
                if let _lastName = JSON["lastname"] as? String {
                    mainUser?.lastname = _lastName
                }
                
                
                if !managedContext.save(&error) {
                    println("Could not save \(error), \(error?.userInfo)")
                } else {
                    success()
                }
            } else {
                println("Could not fetch \(error)")
            }

        }
    }
    
    
    /**
    Log out user from app
    
    :param: success
    :param: failure
    */
    func logout(success: () -> Void, failure: () -> Void) {
        let url: String = "https://\(APIURL)/api/mobile/auth/logout"
        
        Alamofire.request(.GET, url, parameters: nil)
            .response { (request, response, _, error) in
                if (error != nil) {
                    failure()
                } else {
                    let error = Locksmith.deleteDataForUserAccount("UnserAllerUser", inService: "UnserAller")
                    
                    success()
                }
                
        }
    }
}