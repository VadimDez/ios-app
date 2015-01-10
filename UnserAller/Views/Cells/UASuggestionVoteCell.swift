//
//  UASuggestionVoteCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 10/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionVoteCell: UACell {

    @IBOutlet weak var rating: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellForHome(suggestion: UASuggestion) {
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = self.getStringFromDate(suggestion.updated)
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
    }
    
    func setCellForPhase(suggestion: UASuggestion) {
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = self.getStringFromDate(suggestion.updated)
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
    }
}
