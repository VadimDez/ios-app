//
//  UASuggestionHeaderView.swift
//  UnserAller
//
//  Created by Vadim Dez on 16/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class UASuggestionHeaderView: UIView {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var secondaryImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var projectButton: UIButton!
    
    var suggestion: UASuggestion!
    
    @IBOutlet weak var newCommentButton: UIButton!
    @IBOutlet weak var newCommentInput: UITextField!
    @IBOutlet weak var sendNewCommentButton: UIButton!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func adjustHeight(content: String, imageQuantity: Int) {
//        var frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 90.0)
        let base = CGFloat(105.0)//CGFloat(76.0)
        
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
    
    /**
    Load profileImage
    
    :param: hash   String
    :param: width  Uint
    :param: height Uint
    */
    func loadMainImage(hash: UInt, width: UInt, height: UInt) {
        self.loadImage(self.mainImage, url: "\(APIURL)/media/profileimage/\(hash)/\(height)/\(width)")
    }
    
    /**
    Load project image
    
    :param: hash   String
    :param: width  Uint
    :param: height Uint
    */
    func loadProjectImage(projectId: UInt, width: UInt, height: UInt) {
        self.loadImage(self.secondaryImage, url: "\(APIURL)/api/v1/media/project/\(projectId)/\(height)/\(width)")
    }
    
    func loadImage(imageView: UIImageView, url: String) {
        let request = NSURLRequest(URL: NSURL(string: url)!)
        
        imageView.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            
            imageView.image = image
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
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
    
    /**
    *  Send like
    */
    func sendLike(id: UInt, success: (active: Bool) -> Void, failure: () -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIURL)/api/v1/suggestion/like"
        
        Alamofire.request(.GET, url, parameters: ["id": id])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success(active: ((JSON?.objectForKey("status") as! String) == "active"))
                }
        }
    }
}
