//
//  UACell.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        return dateFormatter.stringFromDate(date)
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
            // test
            if let weakSelf = self {
                weakSelf.mainImage.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
    }
}
