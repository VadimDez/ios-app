//
//  UACommentViewModel.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UACommentViewModel {
    
    
    /**
    *  Get comments array from JSON
    *  used for suggestion view
    **/
    func getCommentsFromJSON(data: [Dictionary<String, AnyObject>]) -> [UAComment] {

        var comments: [UAComment] = []
        
        for object in data {
            comments.append(UAComment().initCommentWithJSON(object as Dictionary<String, AnyObject>))
        }
        println(comments.count)
        return comments
    }
}
