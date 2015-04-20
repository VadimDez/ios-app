//
//  UACommentWithImageCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 18/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACommentWithImageCell: UACell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var comment: UAComment!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        
        self.registerNibs()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerNibs() {
        var UACollectionViewCellNib = UINib(nibName: "UACollectionViewCell", bundle: nil)
        self.imageCollectionView.registerNib(UACollectionViewCellNib, forCellWithReuseIdentifier: "UACollectionViewCell")
    }
    
    /**
    Sec comment cell
    
    :param: comment Comment object
    */
    func setCell(comment: UAComment) {
        self.comment = comment
        self.titleLabel?.text   = comment.user.fullName
        self.contentLabel?.text = comment.content
        self.dateLabel?.text    = self.getStringFromDate(comment.updated)
        
        self.makeRoundCorners()
        self.loadMainImage(comment.user.id, width: 35, height: 35)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comment.media.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UACollectionViewCell = self.imageCollectionView.dequeueReusableCellWithReuseIdentifier("UACollectionViewCell", forIndexPath: indexPath) as! UACollectionViewCell
        cell.setCell(self.comment.media[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object: Dictionary<String, AnyObject> = ["actual": indexPath.row, "media": self.comment.media]
        
        NSNotificationCenter.defaultCenter().postNotificationName("didSelectItemFromCollectionView", object: object)
    }
}
