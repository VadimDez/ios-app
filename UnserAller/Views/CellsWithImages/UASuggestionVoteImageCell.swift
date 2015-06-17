//
//  UASuggestionVoteImageCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 12/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionVoteImageCell: UACell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    var medias: [UAMedia] = []
    
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
        self.imageCollectionView.backgroundColor    = UIColor.clearColor()
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = suggestion.projectName
        self.dateLabel.text         = suggestion.updated.getStringFromDate()
        self.ratingView.rating      = Float(suggestion.userVotes)
        self.likeLabel.text         = "\(suggestion.likeCount)"
        self.commentLabel.text      = "\(suggestion.commentCount)"
        self.medias                 = suggestion.media
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.loadProjectImage(suggestion.projectId, width: 20, height: 20)
        self.imageCollectionView.reloadData()
    }
    
    func setCellForPhase(suggestion: UASuggestion) {
        self.imageCollectionView.backgroundColor    = UIColor.clearColor()
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.subtitleLabel.text     = ""
        self.dateLabel.text         = suggestion.updated.getStringFromDate()
        self.ratingView.rating      = Float(suggestion.userVotes)
        self.likeLabel.text         = "\(suggestion.likeCount)"
        self.commentLabel.text      = "\(suggestion.commentCount)"
        self.medias                 = suggestion.media
        
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        self.secondaryImage.backgroundColor = UIColor.clearColor()
        self.imageCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UACollectionViewCell = self.imageCollectionView.dequeueReusableCellWithReuseIdentifier("UACollectionViewCell", forIndexPath: indexPath) as! UACollectionViewCell
        cell.setCell(self.medias[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object: Dictionary<String, AnyObject> = ["actual": indexPath.row, "media": self.medias]
        
        NSNotificationCenter.defaultCenter().postNotificationName("didSelectItemFromCollectionView", object: object)
    }
}
