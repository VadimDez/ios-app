//
//  UASuggestionVoteCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 10/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionVoteCell: UACell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
//    var _suggestion: UASuggestion!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.titleLabel.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top;
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellForHome(suggestion: UASuggestion) {
//        self._suggestion = suggestion
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = suggestion.projectName
        self.dateLabel.text         = suggestion.updated.getStringFromDate()
        self.ratingView.rating      = Float(suggestion.userVotes)
        self.likeLabel.text         = "\(suggestion.likeCount)"
        self.commentLabel.text      = "\(suggestion.commentCount)"
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.loadProjectImage(suggestion.projectId, width: 20, height: 20)
    }
    
    func setCellForPhase(suggestion: UASuggestion) {
//        self._suggestion = suggestion
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = ""
        self.dateLabel.text         = suggestion.updated.getStringFromDate()
        self.ratingView.rating      = Float(suggestion.userVotes)
        self.likeLabel.text         = "\(suggestion.likeCount)"
        self.commentLabel.text      = "\(suggestion.commentCount)"
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.secondaryImage.backgroundColor = UIColor.whiteColor()
    }
    
    func setCellForActivity(suggestion: UASuggestion) {
//        self._suggestion = suggestion
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = suggestion.projectName
        self.dateLabel.text         = suggestion.updated.getStringFromDate()
        self.ratingView.rating      = Float(suggestion.userVotes)
        self.likeLabel.text         = "\(suggestion.likeCount)"
        self.commentLabel.text      = "\(suggestion.commentCount)"
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.loadProjectImage(suggestion.projectId, width: 20, height: 20)
    }
}
