//
//  UALikertCompetence.swift
//  UnserAller
//
//  Created by Vadym on 16/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class UALikertCompetence: UACompetenceWithOptions {
    override init() {
        super.init()
        self.format = CompetenceFormat.Likert
        self.cellType = "UALikertCell"
    }
}