//
//  UASuggestionCell.swift
//  UnserAller
//
//  Created by Vadym on 09/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionCell: UACell {
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var suggestionId: UInt = 0
    var projectId: UInt = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellForHome(suggestion: UASuggestion) {
        
        self.contentLabel?.text     = suggestion.content
        self.titleLabel?.text       = suggestion.userName
        self.subtitleLabel?.text    = suggestion.projectName
        self.likeLabel?.text        = "\(suggestion.likeCount)"
        self.commentLabel?.text     = "\(suggestion.commentCount)"
        self.suggestionId           = suggestion.suggestionId
        self.projectId              = suggestion.projectId
        self.dateLabel?.text = self.getStringFromDate(suggestion.updated)

        // load profile image
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        
        // change shape of image
        self.makeRoundCorners()
    }

    func setCellForPhase(suggestion: UASuggestion) {
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.likeLabel.text         = "\(suggestion.likeCount)"
        self.commentLabel.text      = "\(suggestion.commentCount)"
        self.subtitleLabel.text     = self.getStringFromDate(suggestion.updated)
        self.dateLabel.text         = ""
        self.suggestionId           = suggestion.suggestionId
        
        // change shape of image
        self.makeRoundCorners()
        
        // load profile image
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        
    }
}
