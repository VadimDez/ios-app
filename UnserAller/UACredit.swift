//
//  UACredit.swift
//  UnserAller
//
//  Created by Vadim Dez on 10/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UACredit {
    var project: UAProject
    var totalCredits: Int = 0
    var suggestion: Int = 0
    var comment: Int = 0
    var like: Int = 0
    var vote: Int = 0
    var media: Int = 0
    var backlink: Int = 0
    var competence: Int = 0
    
    init() {
        self.project = UAProject()
    }
    
}