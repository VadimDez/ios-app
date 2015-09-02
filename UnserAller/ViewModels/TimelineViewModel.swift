//
//  TimelineViewModel.swift
//  UnserAller
//
//  Created by Vadim Dez on 03/07/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

class TimelineViewModel {
    var suggestionViewModel: UASuggestionViewModel!
    var newsViewModel: UANewsViewModel!
    
    init() {
        self.suggestionViewModel = UASuggestionViewModel()
        self.newsViewModel = UANewsViewModel()
    }
    
    func getObjectsFromJSON(data: [Dictionary<String, AnyObject>]) -> [UACellObject] {
        var timelineObjects: [UACellObject] = []

        for object in data {
            if (object["suggestion"] != nil && !(object["suggestion"] is NSNull)) {
                timelineObjects.append(self.getSuggestion(object))
            } else {
                timelineObjects.append(self.newsViewModel.parseNewsForTimeline(object))
            }
        }
        
        return timelineObjects
    }
    
    func getSuggestion(object: Dictionary<String, AnyObject>) -> UASuggestion {
        
        self.suggestionViewModel.suggestion = UASuggestion()
        
        self.suggestionViewModel.parseSuggestion(object)
        
        return self.suggestionViewModel.suggestion
    }
}