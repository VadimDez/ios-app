//
//  UAFreetextCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAFreetextCell: UACompetenceCell {

    override func setupCell(competence: UACompetence) {
        self.competence = competence
        self.contentLabel.text = competence.content
    }
}
