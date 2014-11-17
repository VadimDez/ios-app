//
//  UASuggestionViewModel.swift
//  UnserAller
//
//  Created by Vadym on 06/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UASuggestionViewModel {
    
    var suggestion: UASuggestion = UASuggestion()
    
    
    /**
     *  Get suggestions array from JSON
     *  used for HOME
     **/
    func getSuggestionsFromJSON(data: [Dictionary<String, AnyObject>]) -> [UASuggestion] {
        var suggestions: [UASuggestion] = []
        
        for object in data {
            // clean
            suggestion = UASuggestion()
            
            // check if empty
            // TODO: needs to be validated
            if object["suggestion"] != nil {
                
                if object["media"] != nil {
                    
                    if (object["type"]?.isEqualToString("suggest") == true) {
                        self.getSuggestIncludingImages(object)
                    } else {
                        self.getVoteIncludeImagesWithObject(object)
                    }
                } else {
                    
                    if (object["type"]?.isEqualToString("suggest") == true) {
                        self.getSuggestion(object)
                    } else {
                        self.getVote(object)
                    }
                }
                
            } else {
                if (object["media"] != nil) {
                    self.getNewsIncludeImages(object)
                } else {
                    self.getNews(object)
                }
            }
            
            // add suggestion object to array
            suggestions.append(suggestion)
        }
        
        return suggestions
    }
    
    
    // home
    func getSuggestion(object: AnyObject) {
        suggestion = UASuggestion().initSuggestion(object)
    }
    func getVote(object: AnyObject) {
        suggestion = UASuggestion().initVote(object)
    }
    func getNews(object: AnyObject) {
        suggestion = UASuggestion().initNews(object)
    }
    func getNewsIncludeImages(object: AnyObject) {
        suggestion = UASuggestion().initNewsIncludeImages(object)
    }
    func getSuggestIncludingImages(object: AnyObject) {
        suggestion = UASuggestion().initSuggestIncludingImages(object)
    }
    func getVoteIncludeImagesWithObject(object: AnyObject) {
        suggestion = UASuggestion().initVoteIncludingImages(object)
    }
    
    
    func getSuggestionsForActivityFromJSON(data: [Dictionary<String, AnyObject>]) -> [UASuggestion] {
        var suggestions: [UASuggestion] = []
        
        for object in data {
            // clean
            suggestion = UASuggestion()
            
            // check if empty
            // TODO: needs to be validated
            if object["suggestion"] != nil {
                
                if object["mediaSuggestion"] != nil {
                    
                    if (object["suggestionType"]?.isEqualToString("suggest") == true) {
                        self.getSuggestIncludeImagesForActivityWithObject(object)
                    } else {
                        self.getVoteIncludeImagesForActivityWithObject(object)
                    }
                } else {
                    
                    if (object["suggestionType"]?.isEqualToString("suggest") == true) {
                        self.getSuggestForActivityWithObject(object)
                    } else {
                        self.getVoteForActivityWithObject(object)
                    }
                }
                
            }
            
            // add suggestion object to array
            suggestions.append(suggestion)
        }
        
        
        return suggestions
    }
    
    // activity
    func getSuggestIncludeImagesForActivityWithObject(object: AnyObject) {
        suggestion = UASuggestion().initSuggestForActivity(object)
    }
    func getVoteIncludeImagesForActivityWithObject(object: AnyObject) {
        suggestion = UASuggestion()
    }
    func getSuggestForActivityWithObject(object: AnyObject) {
        suggestion = UASuggestion()
    }
    func getVoteForActivityWithObject(object: AnyObject) {
        suggestion = UASuggestion()
    }
}