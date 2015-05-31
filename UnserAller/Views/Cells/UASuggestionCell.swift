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
    var suggestion: UASuggestion!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
    Like suggestion
    
    :param: sender
    */
    @IBAction func like(sender: AnyObject) {
        self.sendLike(self.suggestion.suggestionId, success: { (active) -> Void in
            let increment = (active) ? 1 : -1;
            self.suggestion.likeCount = self.suggestion.likeCount + increment;
            self.likeLabel.text = "\(self.suggestion.likeCount)"
        }) { () -> Void in
            
        }
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
        
    }
}
