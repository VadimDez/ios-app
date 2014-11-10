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
    var id: Int!
    var name: String!
    var title: String!
    var company: String!
    
    init() {
        
    }
    
    func initWithParams(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}