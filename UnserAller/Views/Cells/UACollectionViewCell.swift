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
    
    func setCell(media: UAMedia) {
        
        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "\(APIPROTOCOL)://\(APIURL)/media/crop/\(media.hash)/35/35")!)
        self.image.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            // test
            if let weakSelf = self {
                weakSelf.image.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
        
    }
}
