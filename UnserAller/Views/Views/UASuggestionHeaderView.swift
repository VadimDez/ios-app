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
    @IBOutlet weak var likeImage: UIImageView!
    
    var suggestion: UASuggestion!
    
    @IBOutlet weak var newCommentButton: UIButton!
    @IBOutlet weak var newCommentInput: UITextField!
    @IBOutlet weak var sendNewCommentButton: RNLoadingButton!
    
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
        
        var media:CGFloat = 0.0
        if (imageQuantity > 0) {
            media = 51.0 + CGFloat((imageQuantity/5) * 51)
        }

        self.frame.size.height = base + content.getHeightForView(self.contentLabel.frame.width, font: UIFont(name: "Helvetica Neue", size: 14)!) + media
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
        
        let incrementBefore: Int = self.suggestion.userVotes > 0 ? -1 : 1
        self.updateLike(incrementBefore)
        
        self.sendLike(self.suggestion.suggestionId, success: { (active) -> Void in
            let increment = (active) ? 1 : -1;
            
            if incrementBefore != increment {
                
                self.updateLike(increment - incrementBefore)
            }
            
            }) { () -> Void in
                self.updateLike(-incrementBefore)
        }
    }
    
    func updateLike(increment: Int) {
        self.suggestion.userVotes += increment
        self.suggestion.likeCount = self.suggestion.likeCount + increment
        self.likeLabel.text = "\(self.suggestion.likeCount)"
        
        self.toggleLikeColor()
    }
    
    // toggle like color
    func toggleLikeColor() -> Void {
        // if liked - tint heart
        if (suggestion.userVotes > 0) {
            self.likeImage.image = UIImage(named: "heart_red")
        } else {
            self.likeImage.image = UIImage(named: "heart_black_32")
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
