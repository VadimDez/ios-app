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
    @IBOutlet weak var mainView: UIView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    func setUp(suggestion: UASuggestion) {
        self.titleLabel.text    = suggestion.userName
        self.projectButton.setTitle(suggestion.projectName, forState: UIControlState.Normal)
//        self.subtitleLabel.text = suggestion.projectName
        self.contentLabel.text  = suggestion.content
        
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.dateLabel.text     = suggestion.updated.getStringFromDate()
        
        if suggestion.isReleased {
            self.ratingView.rating  = Float(suggestion.userVotes)
            self.likeLabel.text     = "\(suggestion.likeCount)"
        } else {
            if self.ratingView != nil {
                //                self.commentLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
                //                self.mainView.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                //
                let rightConstrain = NSLayoutConstraint(
                    item: self.commentLabel,
                    attribute: NSLayoutAttribute.Right,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self.mainView,
                    attribute: NSLayoutAttribute.Right,
                    multiplier: 1.0,
                    constant: -8.0)
                self.ratingView.removeFromSuperview()
                self.ratingView.removeConstraints(self.ratingView.constraints)
                self.mainView.addConstraint(rightConstrain)
                
            }
            if self.likeLabel != nil {
                self.likeLabel.removeFromSuperview()
                self.likeLabel.removeConstraints(self.likeLabel.constraints)
            }
        }
        
        self.adjustHeight(suggestion.content, imageQuantity: suggestion.media.count)
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 40, height: 40)
        self.loadProjectImage(suggestion.projectId, width: 10, height: 20)
        
        // set button with indicator
        self.sendNewCommentButton.hideTextWhenLoading = true
        self.sendNewCommentButton.setActivityIndicatorAlignment(RNLoadingButtonAlignmentCenter)
        self.sendNewCommentButton.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.Gray, forState: UIControlState.Disabled)
    }
}
