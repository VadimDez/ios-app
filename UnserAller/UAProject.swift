//
//  UAProject.swift
//  UnserAller
//
//  Created by Vadim Dez on 09/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UAProject
{
    var id: UInt!
    var name: String!
    var title: String!
    var company: UACompany!
    var imageHash: String = "new"
    var imageUrl: String = ""
    var bookmarked: Bool = false
    var closedCommunity: Bool = false
    
    init() {
        
    }
    
    func initWithParams(id: UInt, name: String) {
        self.id = id
        self.name = name
    }
}