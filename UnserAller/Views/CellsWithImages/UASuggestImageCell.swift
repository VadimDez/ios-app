//
//  UASuggestImageCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 22/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestImageCell: UACell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var suggestionId: UInt = 0
    var projectId: UInt = 0
    var type:String = "suggestion"
    var medias: [UAMedia] = []
    var suggestion: UASuggestion!
    
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
    
    /**
    Like suggestion
    
    :param: sender
    */
    @IBAction func like(sender: AnyObject) {
        self.sendLike(self.suggestion.suggestionId, success: { (active) -> Void in
            let increment = (active) ? 1 : -1;
            self.suggestion.likeCount = self.suggestion.likeCount + increment;
            self.likeLabel.text = "\(self.suggestion.likeCount)"
            }) { () -> Void in
                
        }
    }
    
    func setCellForHome(suggestion: UASuggestion) {
        self.suggestion = suggestion
        
        self.type = "suggestion";
        //    _collectionDataDictionary = data;
        
        self.imageCollectionView.backgroundColor = UIColor.clearColor()
        
        self.contentLabel.text  = suggestion.content
        self.titleLabel.text    = suggestion.userName
        self.subtitleLabel.text = suggestion.projectName
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.medias             = suggestion.media
        self.dateLabel?.text    = suggestion.updated.getStringFromDate()
        
        // if liked - tint heart
        var color:UIColor
        if (suggestion.userVotes > 0) {
            color = UIColor.redColor()
        } else {
            color = UIColor.grayColor()
        }
//        [_likeButton setImage:[[UIImage imageNamed:@"heart_black_32"] tintedImageWithColor:color] forState:UIControlStateNormal];
//        [_likeButton setTintColor:color];
        
        //    imageList = [dictionary objectForKey:@"media"];
        //    _imageCollectionView.backgroundColor = [UIColor greenColor];
        
        
        self.suggestionId        = suggestion.suggestionId
        self.projectId           = suggestion.projectId
        
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
        //    _collectionDataDictionary = data;
        
        self.imageCollectionView.backgroundColor = UIColor.clearColor()
        
        self.contentLabel.text  = suggestion.content
        self.titleLabel.text    = suggestion.userName
        self.subtitleLabel.text = ""
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.medias             = suggestion.media
        self.dateLabel?.text    = suggestion.updated.getStringFromDate()
        
        // if liked - tint heart
        var color:UIColor
        if (suggestion.userVotes > 0) {
            color = UIColor.redColor()
        } else {
            color = UIColor.grayColor()
        }
        //        [_likeButton setImage:[[UIImage imageNamed:@"heart_black_32"] tintedImageWithColor:color] forState:UIControlStateNormal];
        //        [_likeButton setTintColor:color];
        
        //    imageList = [dictionary objectForKey:@"media"];
        //    _imageCollectionView.backgroundColor = [UIColor greenColor];
        
        
        self.suggestionId        = suggestion.suggestionId
        self.projectId           = suggestion.projectId
        
        // load profile image
        self.loadMainImage(suggestion.userId, width: 35, height: 35)
        
        // clear project image
        self.secondaryImage.backgroundColor = UIColor.whiteColor()
        
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
