//
//  UASuggestionHeaderView.swift
//  UnserAller
//
//  Created by Vadim Dez on 16/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionHeaderView: UIView {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func adjustHeight(content: String, imageQuantity: Int) {
//        var frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 90.0)
        let base = CGFloat(76.0)
        
        // count text height
        var frame: CGRect = CGRect()
        frame.size.width = self.contentLabel.frame.width
        frame.size.height = CGFloat(MAXFLOAT)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = content
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        var media:CGFloat = 0.0
        if (imageQuantity > 0) {
            media = 51.0 + CGFloat((imageQuantity/5) * 51)
        }

        self.frame.size.height = base + label.frame.height + media
    }

    func makeRoundCorners() {
        var imageLayer:CALayer = self.mainImage.layer
        imageLayer.cornerRadius = 20
        imageLayer.masksToBounds = true
    }
    
    func loadMainImage(hash: UInt, width: UInt, height: UInt) {
        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "https://\(APIURL)/media/profileimage/\(hash)/\(height)/\(width)")!)
        self.mainImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            if let weakSelf = self {
                weakSelf.mainImage.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
    }
}
