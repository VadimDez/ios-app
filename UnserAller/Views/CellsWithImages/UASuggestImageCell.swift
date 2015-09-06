//
//  UASuggestImageCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 22/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestImageCell: UACellSuggest, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var type: String = "suggestion"
    var mediaHelper: MediaHelper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // register nibs
        self.registerNibs()
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
    }
    
    /**
    Register all nibs
    */
    func registerNibs() {
        var UACollectionViewCellNib = UINib(nibName: "UACollectionViewCell", bundle: nil)
        self.imageCollectionView.registerNib(UACollectionViewCellNib, forCellWithReuseIdentifier: "UACollectionViewCell")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellForHome(suggestion: UASuggestion) {
        self.suggestion = suggestion
        
        self.type = "suggestion";
        
        self.imageCollectionView.backgroundColor = UIColor.clearColor()
        
        self.contentLabel.text  = suggestion.content
        self.titleLabel.text    = suggestion.userName
        self.subtitleLabel.text = suggestion.projectName
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.dateLabel?.text    = suggestion.updated.getStringFromDate()
        //
        self.suggestionId       = suggestion.suggestionId
        self.projectId          = suggestion.projectId
        
        // if liked - tint heart
        if (suggestion.userVotes > 0) {
            self.likeImage.image = UIImage(named: "heart_red")
        } else {
            self.likeImage.image = UIImage(named: "heart_black_32")
        }
        
        //    imageList = [dictionary objectForKey:@"media"];
        //    _imageCollectionView.backgroundColor = [UIColor greenColor];
        
        
        
        // load profile image
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        
        // load project image
        self.loadProjectImage(suggestion.projectId, width: 20, height: 20)
        
        // change shape of image
        self.makeRoundCorners()
        
        self.mediaHelper = MediaHelper(maxWidth: self.imageCollectionView.frame.width, mediaCount: self.suggestion.media.count)
//        [_collectionView setContentOffset:CGPointZero animated:NO];
//        [_collectionView reloadData];
        self.imageCollectionView.reloadData()
        
    }
    
    
    func setCellForPhase(suggestion: UASuggestion) {
        self.suggestion = suggestion
//        self.mediaHelper = MediaHelper(maxWidth: self.imageCollectionView.frame.width, mediaCount: self.suggestion.media.count)
        
        self.type = "suggestion";
        
        self.imageCollectionView.backgroundColor = UIColor.clearColor()
        
        self.contentLabel.text  = suggestion.content
        self.titleLabel.text    = suggestion.userName
        self.subtitleLabel.text = ""
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.dateLabel?.text    = suggestion.updated.getStringFromDate()

        // if liked - tint heart
        if (suggestion.userVotes > 0) {
            self.likeImage.image = UIImage(named: "heart_red")
        } else {
            self.likeImage.image = UIImage(named: "heart_black_32")
        }
        
        self.suggestionId        = suggestion.suggestionId
        self.projectId           = suggestion.projectId
        
        // load profile image
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        
        // clear project image
        self.secondaryImage.backgroundColor = UIColor.clearColor()
        
        // change shape of image
        self.makeRoundCorners()
        
        //        [_collectionView setContentOffset:CGPointZero animated:NO];
        //        [_collectionView reloadData];
        
        self.mediaHelper = MediaHelper(maxWidth: self.imageCollectionView.frame.width, mediaCount: self.suggestion.media.count)
        self.imageCollectionView.reloadData()
    }

    // MARK: - Collection view
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
        return self.mediaHelper.getSizeForIndex(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
//    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        return !touch.view.isKindOfClass(UICollectionView)
//    }
}
