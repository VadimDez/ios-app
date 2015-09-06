//
//  UACommentService.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation
import Alamofire

class UACommentService {
    
    
    /**
    *  Get comments array from JSON
    *  used for suggestion view
    **/
    func getCommentsFromJSON(data: [Dictionary<String, AnyObject>]) -> [UAComment] {

        var comments: [UAComment] = []
        
        for object in data {
            comments.append(UAComment().initCommentWithJSON(object as Dictionary<String, AnyObject>))
        }
        
        return comments
    }
    
    
    
    /**
    * Delete comment
    */
    func deleteComment(commentId: UInt, success: () -> (), error: () -> ()) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url: String = "\(APIURL)/api/v1/comment/\(commentId)"
        
        Alamofire.request(.DELETE, url, parameters: nil)
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // error block
                    error()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success()
                }
        }
    }
    
    /**
    * Restore comment
    */
    func restoreComment(commentId: UInt, success: () -> (), error: () -> ()) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url: String = "\(APIURL)/api/v1/comment/restore/\(commentId)"
        
        Alamofire.request(.POST, url, parameters: nil)
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // error block
                    error()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success()
                }
        }
    }
    /**
    * Update comment
    */
    func update(comment: UAComment, success: () -> (), error: () -> ()) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url: String = "\(APIURL)/api/v1/comment/update/"
        
        Alamofire.request(.POST, url, parameters: ["id": comment.id, "comment": comment.content, "language": "en"])
            .responseJSON { (_,_,answer,errors) in
                
                if (errors != nil) {
                    // print error
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // error block
                    error()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success()
                }
        }
    }
}
