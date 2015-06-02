//
//  UASuggestionCell.swift
//  UnserAller
//
//  Created by Vadym on 09/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionCell: UACellSuggest {
    var likeRequestFinished: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellForHome(suggestion: UASuggestion) {
        // set suggestion
        self.suggestion = suggestion
        
        self.contentLabel?.text     = suggestion.content
        self.titleLabel?.text       = suggestion.userName
        self.subtitleLabel?.text    = suggestion.projectName
        self.likeLabel?.text        = "\(suggestion.likeCount)"
        self.commentLabel?.text     = "\(suggestion.commentCount)"
        self.suggestionId           = suggestion.suggestionId
        self.projectId              = suggestion.projectId
        self.dateLabel?.text        = suggestion.updated.getStringFromDate()

        // load profile image
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        // load project image
        self.loadProjectImage(suggestion.projectId, width: 20, height: 20)
        
        // change shape of image
        self.makeRoundCorners()
        
        // if liked - tint heart
        self.tintLike(suggestion.userVotes > 0)
    }

    func setCellForPhase(suggestion: UASuggestion) {
        // set suggestion
        self.suggestion = suggestion
        
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.likeLabel.text         = "\(suggestion.likeCount)"
        self.commentLabel.text      = "\(suggestion.commentCount)"
        self.subtitleLabel.text     = ""
        self.dateLabel?.text        = suggestion.updated.getStringFromDate()
        self.suggestionId           = suggestion.suggestionId
        
        // change shape of image
        self.makeRoundCorners()
        
        // load profile image
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        
        // clear project image cell
        self.secondaryImage.backgroundColor = UIColor.clearColor()
        
        // if liked - tint heart
        self.tintLike(suggestion.userVotes > 0)
    }
    

}
