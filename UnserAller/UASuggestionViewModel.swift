//
//  UASuggestionViewModel.swift
//  UnserAller
//
//  Created by Vadym on 06/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Alamofire

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
            
            self.parseSuggestion(object)
            
            // add suggestion object to array
            suggestions.append(suggestion)
        }
        
        return suggestions
    }
    
    func parseSuggestion(object: Dictionary<String, AnyObject>) {
        let isSuggest = ((object["suggestion"]?.objectForKey("phaseType") as! String) == "suggest") ? true : false

        if object["media"] != nil {
            
            if (isSuggest) {
                self.getSuggestIncludingImages(object)
            } else {
                self.getVoteIncludeImagesWithObject(object)
            }
        } else {
            
            if (isSuggest) {
                self.getSuggestion(object)
            } else {
                self.getVote(object)
            }
        }
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
                let isSuggest = ((object["suggestion"]?.objectForKey("phaseType") as! String) == "suggest") ? true : false
                
                if object["suggestion"]?.objectForKey("mediaSuggestion") != nil && object["suggestion"]?.objectForKey("mediaSuggestion")?.count > 0 {
                    
                    if (isSuggest) {
                        self.getSuggestIncludeImagesForActivityWithObject(object)
                    } else {
                        self.getVoteIncludeImagesForActivityWithObject(object)
                    }
                } else {
                    
                    if (isSuggest) {
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
        suggestion = UASuggestion().initSuggestIncludeImagesForActivity(object)
    }
    func getVoteIncludeImagesForActivityWithObject(object: AnyObject) {
        suggestion = UASuggestion().initVoteIncludeImagesForActivity(object)
    }
    func getSuggestForActivityWithObject(object: AnyObject) {
        suggestion = UASuggestion().initSuggestForActivity(object)
    }
    func getVoteForActivityWithObject(object: AnyObject) {
        suggestion = UASuggestion().initVoteForActivity(object)
    }
    
    func getSuggestionsForProjectFromJSON(data: [Dictionary<String, AnyObject>], isNews: Bool, type: String) -> [UASuggestion] {
        var suggestions: [UASuggestion] = []
        
        for object in data {
            
            if (isNews) {
                self.getNewsForProjectWithObject(object)
            } else {
                // media check
                if (object["suggestion"]?.objectForKey("mediaSuggestion")?.count > 0) {
                    // there're medias
                    if let suggestionType = object["suggestionType"] as? String {
                        
                        if (suggestionType == "suggest") {
                            self.getSuggestIncludeImagesForProjectWithObject(object)
                        } else {
                            self.getVoteIncludeImagesForProjectWithObject(object)
                        }
                    }
                } else {
                    // no medias
                    if (type == "suggest") {
                        self.getSuggestForProjectWithObject(object)
                    } else {
                        self.getVoteForProjectWithObject(object)
                    }
                }
            }
            
            // add suggestion to list
            suggestions.append(suggestion)
        }
        
        
        return suggestions
    }
    
    // project
    func getNewsForProjectWithObject(object: AnyObject) {
        suggestion = UASuggestion().initNewsForProjectWithObject(object)
    }
    func getSuggestForProjectWithObject(object: AnyObject) {
        suggestion = UASuggestion().initSuggestForProjectWithObject(object)
    }
    func getVoteForProjectWithObject(object: AnyObject) {
        suggestion = UASuggestion().initVoteForProjectWithObject(object)
    }
    func getSuggestIncludeImagesForProjectWithObject(object: AnyObject) {
        suggestion = UASuggestion().initSuggestIncludeImagesForProjectWithObject(object)
    }
    func getVoteIncludeImagesForProjectWithObject(object: AnyObject) {
        suggestion = UASuggestion().initVoteIncludeImagesForProjectWithObject(object)
    }
    
    func delete(suggestion: UASuggestion, success: () -> Void, error: () -> Void) {
        let url: String = "\(APIURL)/api/v1/suggestion/\(suggestion.suggestionId)"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
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
}