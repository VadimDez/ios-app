//
//  UASuggestionView.swift
//  UnserAller
//
//  Created by Vadim Dez on 15/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionView: UASuggestionHeaderView {

    func setUp(suggestion: UASuggestion) {
        self.suggestion = suggestion
        
        self.titleLabel.text    = suggestion.userName
        self.projectButton.setTitle(suggestion.projectName, forState: UIControlState.Normal)
//        self.subtitleLabel.text = suggestion.projectName
        self.contentLabel.text  = suggestion.content
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.dateLabel.text     = suggestion.updated.getStringFromDate()
        
        self.adjustHeight(suggestion.content, imageQuantity: suggestion.media.count)
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 40, height: 40)
        self.loadProjectImage(suggestion.projectId, width: 10, height: 20)
        
        // if liked - tint heart
        self.toggleLikeColor()
        
        // set button with indicator
        self.sendNewCommentButton.hideTextWhenLoading = true
        self.sendNewCommentButton.setActivityIndicatorAlignment(RNLoadingButtonAlignmentCenter)
        self.sendNewCommentButton.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.Gray, forState: UIControlState.Disabled)
    }
}
