//
//  UASuggestionWithImageView.swift
//  UnserAller
//
//  Created by Vadim Dez on 18/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionWithImageView: UASuggestionHeaderView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var likeImage: UIImageView!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setUp(suggestion: UASuggestion) {
        
        self.suggestion = suggestion
        
        self.registerNibs()
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        
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
        
        // clear color
        self.imageCollectionView.backgroundColor = UIColor.clearColor()
        
        // if liked - tint heart
        if (suggestion.userVotes > 0) {
            self.likeImage.image = UIImage(named: "heart_red")
        } else {
            self.likeImage.image = UIImage(named: "heart_black_32")
        }
    }
    
    func registerNibs() {
        var UACollectionViewCellNib = UINib(nibName: "UACollectionViewCell", bundle: nil)
        self.imageCollectionView.registerNib(UACollectionViewCellNib, forCellWithReuseIdentifier: "UACollectionViewCell")
    }
    
    // MARK: - collection view
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
}
