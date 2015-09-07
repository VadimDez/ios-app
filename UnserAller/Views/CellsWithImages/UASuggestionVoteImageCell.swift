//
//  UASuggestionVoteImageCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 12/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionVoteImageCell: UACell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var mainView: UIView!
    
    var suggestion: UASuggestion!
    var mediaHelper: MediaHelper = MediaHelper()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // register nibs
        var UACollectionViewCellNib = UINib(nibName: "UACollectionViewCell", bundle: nil)
        self.imageCollectionView.registerNib(UACollectionViewCellNib, forCellWithReuseIdentifier: "UACollectionViewCell")
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellForHome(suggestion: UASuggestion) {
        self.suggestion = suggestion
        self.mediaHelper.mediaCount = suggestion.media.count
        
        self.imageCollectionView.backgroundColor    = UIColor.clearColor()
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = suggestion.projectName
        self.dateLabel.text         = suggestion.updated.getStringFromDate()
        self.commentLabel.text      = "\(suggestion.commentCount)"
        
        // check if released
        if suggestion.isReleased {
            self.ratingView.rating = Float(suggestion.userVotes)
            self.likeLabel.text    = "\(suggestion.likeCount)"
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
                self.ratingView.removeConstraints(self.ratingView.constraints())
                self.mainView.addConstraint(rightConstrain)

            }
            if self.likeLabel != nil {
                self.likeLabel.removeFromSuperview()
                self.likeLabel.removeConstraints(self.likeLabel.constraints())
            }
        }
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.loadProjectImage(suggestion.projectId, width: 20, height: 20)
        
        self.imageCollectionView.reloadData()
    }
    
    func setCellForPhase(suggestion: UASuggestion) {
        self.suggestion = suggestion
        self.mediaHelper.mediaCount = suggestion.media.count
        
        self.imageCollectionView.backgroundColor    = UIColor.clearColor()
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = ""
        self.dateLabel.text         = suggestion.updated.getStringFromDate()
        self.commentLabel.text      = "\(suggestion.commentCount)"
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.secondaryImage.backgroundColor = UIColor.clearColor()
        self.imageCollectionView.reloadData()
        
        
        // check if released
        if suggestion.isReleased {
            // let length = self.ratingView.constraints().count
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
                
                self.ratingView.removeFromSuperview()
                self.ratingView.removeConstraints(self.ratingView.constraints())
                self.mainView.addConstraint(rightConstrain)
            }
            if self.likeLabel != nil {
                self.likeLabel.removeFromSuperview()
                self.likeLabel.removeConstraints(self.likeLabel.constraints())
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.suggestion.media.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UACollectionViewCell = self.imageCollectionView.dequeueReusableCellWithReuseIdentifier("UACollectionViewCell", forIndexPath: indexPath) as! UACollectionViewCell
        cell.setCell(self.suggestion.media[indexPath.row])
        return cell
    }
    
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
