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
     **/
    func getSuggestionsFromJSON(data: [Dictionary<String, AnyObject>]) -> [UASuggestion] {
        var suggestions: [UASuggestion] = []
        
        for object in data {
            // check if empty
            // TODO: needs to be validated
            if object["suggestion"] != nil {
                
                if object["media"] != nil {
                    
                    if (object["type"]?.isEqualToString("suggest") == true) {

                    } else {

                    }
                } else {
                    
                    if (object["type"]?.isEqualToString("suggest") == true) {
                        self.getSuggestion(object)
                    } else {
                        
                    }
                }
                
            } else {
                if (object["media"] != nil) {
                    
                } else {
                    
                }
            }
        }
        
        return suggestions
    }
    
    
    // home
    func getSuggestion(object: AnyObject) {
        suggestion = UASuggestion().initSuggestion(object)
    }
}