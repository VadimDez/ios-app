//
//  UASuggestionCell.swift
//  UnserAller
//
//  Created by Vadym on 09/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionCell: UACell {
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var suggestionId: UInt = 0
    var projectId: UInt = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makeRoundCorners() {
        var imageLayer:CALayer = self.mainImage.layer
        imageLayer.cornerRadius = 20
        imageLayer.masksToBounds = true
    }
    
    func setCellForHome(suggestion: UASuggestion) {
        
        self.contentLabel?.text     = suggestion.content
        self.titleLabel?.text       = suggestion.userName
        self.subtitleLabel?.text    = suggestion.projectName
        self.likeLabel?.text        = "\(suggestion.likeCount)"
        self.commentLabel?.text     = "\(suggestion.commentCount)"
        self.suggestionId           = suggestion.suggestionId
        self.projectId              = suggestion.projectId
        self.dateLabel?.text = self.getStringFromDate(suggestion.updated)

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
        self.makeRoundCorners()
    }

    func setCellForPhase(suggestion: UASuggestion) {
        self.contentLabel.text      = suggestion.content
        self.titleLabel.text        = suggestion.userName
        self.likeLabel.text         = "\(suggestion.likeCount)"
        self.commentLabel.text      = "\(suggestion.commentCount)"
        self.subtitleLabel.text     = self.getStringFromDate(suggestion.updated)
        self.dateLabel.text         = ""
        self.suggestionId           = suggestion.suggestionId
        
        // change shape of image
        self.makeRoundCorners()
        
        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "https://\(APIURL)/media/profileimage/\(suggestion.userId)/35/35")!)
        self.mainImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            // test
            if let weakSelf = self {
                weakSelf.mainImage.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
        
    }
}
