//
//  UACreditViewModel.swift
//  UnserAller
//
//  Created by Vadim Dez on 16/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UACreditViewModel: NSObject {
    /**
    *  Make a Credits array from JSON
    */
    func getCreditsFromJSON(data: [Dictionary<String, AnyObject>]) -> [UACredit] {
        var credits: [UACredit] = []
        
        for object in data {
            let credit: UACredit = UACredit()
            
            if let backlink = object["backlink"] as? Dictionary<String, AnyObject> {
                if let backlinkCredits = backlink["credits"] as? Int {
                    credit.backlink = backlinkCredits
                }
            }
            if let comment = object["comment"] as? Dictionary<String, AnyObject> {
                if let commentCredits = comment["credits"] as? Int {
                    credit.comment = commentCredits
                }
            }
            if let suggestion = object["suggestion"] as? Dictionary<String, AnyObject> {
                if let suggestionCredits = suggestion["credits"] as? Int {
                    credit.suggestion = suggestionCredits
                }
            }
            if let vote = object["vote"] as? Dictionary<String, AnyObject> {
                if let voteCredits = vote["credits"] as? Int {
                    credit.vote = voteCredits
                }
            }
            if let like = object["like"] as? Dictionary<String, AnyObject> {
                if let likeCredits = like["credits"] as? Int {
                    credit.like = likeCredits
                }
            }
            if let media = object["media"] as? Dictionary<String, AnyObject> {
                if let mediaCredits = media["credits"] as? Int {
                    credit.media = mediaCredits
                }
            }
            if let competence = object["competences"] as? Dictionary<String, AnyObject> {
                if let competenceCredits = competence["credits"] as? Int {
                    credit.competence = competenceCredits
                }
            }
            
            if let totalCredits = object["totalCredits"] as? Int {
                credit.totalCredits = totalCredits
            }
            
            if let projectJSON = object["project"] as? Dictionary<String, AnyObject> {
                
                if let projectId = projectJSON["id"] as? UInt {
                    credit.project.id = projectId
                }
                
                if let projectName = projectJSON["name"] as? String {
                    credit.project.name = projectName
                }
            }
            
            credits.append(credit)
        }
        
        return credits

    }
}