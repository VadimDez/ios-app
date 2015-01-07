//
//  UANewsCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UANewsCell: UACell {
    
    func setCellForHome(suggestion: UASuggestion) { println(suggestion)
        self.titleLabel.text = suggestion.projectName
        self.contentLabel.text = suggestion.content
        self.subtitleLabel.text = ""
        
        // make round corners
        var imageLayer: CALayer = self.mainImage.layer
        imageLayer.cornerRadius = 20
        imageLayer.masksToBounds = true
    }
}
