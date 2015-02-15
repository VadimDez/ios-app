//
//  UANewsViewModel.swift
//  UnserAller
//
//  Created by Vadim Dez on 06/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UANewsViewModel {
    
    func getNewsForProject(data: [Dictionary<String, AnyObject>]) -> [UANews] {
        var newsArray: [UANews] = []
        
        for object in data {
            var news = UANews().initNewsForProjectWithObject(object)
            newsArray.append(news)
        }
        
        return newsArray
    }
    
}