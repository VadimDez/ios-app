//
//  UASuggestionVoteWithImageView.swift
//  UnserAller
//
//  Created by Vadim Dez on 18/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionVoteWithImageView: UASuggestionHeaderView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var viewContainer: UIView!
    
    var mediaHelper: MediaHelper = MediaHelper()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    func setUp(suggestion: UASuggestion) {
        self.suggestion = suggestion
        self.mediaHelper.mediaCount = self.suggestion.media.count
        
        self.registerNibs()
        
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
                let rightConstrain = NSLayoutConstraint(
                    item: self.commentLabel,
                    attribute: NSLayoutAttribute.Right,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self.viewContainer,
                    attribute: NSLayoutAttribute.Right,
                    multiplier: 1.0,
                    constant: -8.0)
                self.ratingView.removeFromSuperview()
                self.ratingView.removeConstraints(self.ratingView.constraints())
                self
                self.viewContainer.addConstraint(rightConstrain)
                
            }
            if self.likeLabel != nil {
                self.likeLabel.removeFromSuperview()
                self.likeLabel.removeConstraints(self.likeLabel.constraints())
            }
        }
        
        self.adjustHeight(suggestion.content, imageQuantity: suggestion.media.count)
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 40, height: 40)
        self.loadProjectImage(suggestion.projectId, width: 10, height: 20)
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        
        // clear color
        self.imageCollectionView.backgroundColor = UIColor.clearColor()
        
        // set button with indicator
        self.sendNewCommentButton.hideTextWhenLoading = true
        self.sendNewCommentButton.setActivityIndicatorAlignment(RNLoadingButtonAlignmentCenter)
        self.sendNewCommentButton.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.Gray, forState: UIControlState.Disabled)
    }
    
    func registerNibs() {
        var UACollectionViewCellNib = UINib(nibName: "UACollectionViewCell", bundle: nil)
        self.imageCollectionView.registerNib(UACollectionViewCellNib, forCellWithReuseIdentifier: "UACollectionViewCell")
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.suggestion.media.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UACollectionViewCell = self.imageCollectionView.dequeueReusableCellWithReuseIdentifier("UACollectionViewCell", forIndexPath: indexPath) as! UACollectionViewCell
        
        cell.size = self.mediaHelper.getSizeForIndex(indexPath.row)
        cell.setCell(self.suggestion.media[indexPath.row])
        
        return cell
    }
    
    // custom sizes
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let size = CGFloat((self.imageCollectionView.frame.size.width - 10) / 2.0)
//        return CGSizeMake(size, size)
//    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object: Dictionary<String, AnyObject> = ["actual": indexPath.row, "media": self.suggestion.media]
        
        NSNotificationCenter.defaultCenter().postNotificationName("didSelectItemFromCollectionView", object: object)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.mediaHelper.frameMaxWidth = self.imageCollectionView.bounds.width
        return self.mediaHelper.getSizeForIndex(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
}
