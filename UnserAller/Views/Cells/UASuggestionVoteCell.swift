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
    
    @IBOutlet weak var mainView: UIView!
    
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
        self.commentLabel.text      = "\(suggestion.commentCount)"
        
        // check if released
        if suggestion.isReleased {
            let length = self.ratingView.constraints().count
//            for var i = 0; i < length; i = i + 1 {
//                println((self.ratingView.constraints()[i] as! NSLayoutConstraint).description)
//            }
            self.ratingView.rating = Float(suggestion.userVotes)
            self.likeLabel.text    = "\(suggestion.likeCount)"
        } else {
            if self.ratingView != nil {
//                self.commentLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
//                self.mainView.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                
                let rightConstrain = NSLayoutConstraint(
                    item: self.commentLabel,
                    attribute: NSLayoutAttribute.Right,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self.mainView,
                    attribute: NSLayoutAttribute.Right,
                    multiplier: 1.0,
                    constant: -9.0)

                
                self.ratingView.removeConstraints(self.ratingView.constraints())
                self.mainView.addConstraint(rightConstrain)
                self.ratingView.removeFromSuperview()
            }
            if self.likeLabel != nil {
                self.likeLabel.removeFromSuperview()
            }
        }
        
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
        self.commentLabel.text      = "\(suggestion.commentCount)"
        
        if suggestion.isReleased {
            self.ratingView.rating = Float(suggestion.userVotes)
            self.likeLabel.text    = "\(suggestion.likeCount)"
        } else {
            if self.ratingView != nil {
                
                let rightConstrain = NSLayoutConstraint(
                    item: self.commentLabel,
                    attribute: NSLayoutAttribute.Right,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self.mainView,
                    attribute: NSLayoutAttribute.Right,
                    multiplier: 1.0,
                    constant: -9.0)
                
                
                self.ratingView.removeConstraints(self.ratingView.constraints())
                self.mainView.addConstraint(rightConstrain)
                self.ratingView.removeFromSuperview()
            }
            if self.likeLabel != nil {
                self.likeLabel.removeFromSuperview()
            }
        }
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.secondaryImage.backgroundColor = UIColor.clearColor()
    }
    
    func setCellForActivity(suggestion: UASuggestion) {
//        self._suggestion = suggestion
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = suggestion.projectName
        self.dateLabel.text         = suggestion.updated.getStringFromDate()
        self.commentLabel.text      = "\(suggestion.commentCount)"
        
        if suggestion.isReleased {
            self.ratingView.rating = Float(suggestion.userVotes)
            self.likeLabel.text    = "\(suggestion.likeCount)"
        } else {
            if self.ratingView != nil {
                
                let rightConstrain = NSLayoutConstraint(
                    item: self.commentLabel,
                    attribute: NSLayoutAttribute.Right,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self.mainView,
                    attribute: NSLayoutAttribute.Right,
                    multiplier: 1.0,
                    constant: -9.0)
                
                
                self.ratingView.removeConstraints(self.ratingView.constraints())
                self.mainView.addConstraint(rightConstrain)
                self.ratingView.removeFromSuperview()
            }
            if self.likeLabel != nil {
                self.likeLabel.removeFromSuperview()
            }
        }
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.loadProjectImage(suggestion.projectId, width: 20, height: 20)
    }
}
