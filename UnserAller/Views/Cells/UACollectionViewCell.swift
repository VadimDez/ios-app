//
//  UACollectionViewCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 22/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    var size = CGSize(width: 35.0, height: 35.0)
    
    func setCell(media: UAMedia) {
        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "\(APIURL)/media/crop/\(media.hash)/\(UInt(self.size.height))/\(UInt(self.size.height))")!)
        self.image.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            // test
            if let weakSelf = self {
                weakSelf.image.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
        
    }
}
