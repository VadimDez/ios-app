//
//  UASuggestImageCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 22/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestImageCell: UACellSuggest, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var type:String = "suggestion"
    var medias: [UAMedia] = []
    
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
        self.medias             = suggestion.media
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
        
//        [_collectionView setContentOffset:CGPointZero animated:NO];
//        [_collectionView reloadData];
    }
    
    
    func setCellForPhase(suggestion: UASuggestion) {
        self.suggestion = suggestion
        
        self.type = "suggestion";
        
        self.imageCollectionView.backgroundColor = UIColor.clearColor()
        
        self.contentLabel.text  = suggestion.content
        self.titleLabel.text    = suggestion.userName
        self.subtitleLabel.text = ""
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.medias             = suggestion.media
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
    }

    // MARK: - Collection view
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
