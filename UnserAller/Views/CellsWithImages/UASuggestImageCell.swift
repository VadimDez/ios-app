//
//  UASuggestImageCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 22/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestImageCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var mainImage: UIImageView!
    
    var suggestionId: UInt = 0
    var projectId: UInt = 0
    var type:String = "suggestion"
    var medias: [UAMedia] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellForHome(suggestion: UASuggestion) {
        self.type = "suggestion";
        //    _collectionDataDictionary = data;
        
        self.imageCollectionView.backgroundColor = UIColor.clearColor()
        
        self.contentLabel.text  = suggestion.content
        self.titleLabel.text    = suggestion.userName
        self.subtitleLabel.text = suggestion.projectName
        self.likeLabel.text     = "\(suggestion.likeCount)"
        self.commentLabel.text  = "\(suggestion.commentCount)"
        self.medias             = suggestion.media
        
        
        // date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        // set date
        self.dateLabel?.text = dateFormatter.stringFromDate(suggestion.updated)
        
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
        let request = NSURLRequest(URL: NSURL(string: "https://\(APIURL)/media/profileimage/\(suggestion.userId)/35/35")!)
        self.mainImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            // test
            if let weakSelf = self {
                weakSelf.mainImage.image = image
            }
        }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
            
        }
        
        // change shape of image
        var imageLayer:CALayer = self.mainImage.layer
        imageLayer.cornerRadius = 20
        imageLayer.masksToBounds = true
        
//        [_collectionView setContentOffset:CGPointZero animated:NO];
//        [_collectionView reloadData];
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("\(medias.count)")
        return medias.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        var cell: UICollectionViewCell = UICollectionViewCell()
//        cell.backgroundColor = UIColor.redColor()
        return UICollectionViewCell()
    }
}
