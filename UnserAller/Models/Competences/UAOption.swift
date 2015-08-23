//
//  UAOption.swift
//  UnserAller
//
//  Created by Vadym on 16/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UAOption {
    var value: String!
    var name: String!
    var isSelected: Bool = false
    
    init(name: String, value: String) {
        self.value = value
        self.name = name
    }
}