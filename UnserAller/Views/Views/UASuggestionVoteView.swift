//
//  UASuggestionVoteView.swift
//  UnserAller
//
//  Created by Vadim Dez on 18/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionVoteView: UASuggestionHeaderView {
    
    @IBOutlet weak var ratingView: FloatRatingView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    func setUp(suggestion: UASuggestion) {
        self.titleLabel.text    = suggestion.userName
        self.subtitleLabel.text = suggestion.projectName
        self.contentLabel.text  = suggestion.content
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.dateLabel.text     = suggestion.updated.getStringFromDate()
        self.ratingView.rating  = Float(suggestion.userVotes)
        
        self.adjustHeight(suggestion.content, imageQuantity: suggestion.media.count)
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 40, height: 40)
        self.loadProjectImage(suggestion.projectId, width: 10, height: 20)
    }
}
