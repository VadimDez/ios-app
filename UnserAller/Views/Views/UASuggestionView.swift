//
//  UASuggestionView.swift
//  UnserAller
//
//  Created by Vadim Dez on 15/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionView: UASuggestionHeaderView {
    @IBOutlet weak var likeImage: UIImageView!

    func setUp(suggestion: UASuggestion) {
        self.suggestion = suggestion
        
        self.titleLabel.text    = suggestion.userName
        self.subtitleLabel.text = suggestion.projectName
        self.contentLabel.text  = suggestion.content
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.dateLabel.text     = suggestion.updated.getStringFromDate()
        
        self.adjustHeight(suggestion.content, imageQuantity: suggestion.media.count)
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 40, height: 40)
        
        
        // if liked - tint heart
        if (suggestion.userVotes > 0) {
            self.likeImage.image = UIImage(named: "heart_red")
        } else {
            self.likeImage.image = UIImage(named: "heart_black_32")
        }
    }
}
