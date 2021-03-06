//
//  UACell.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class UACell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var secondaryImage: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    
    var likeRequest: Request!
    var onMainButton: () -> Void = {
        () -> Void in
    }
    
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
    *  Send like
    */
    func sendLike(id: UInt, success: (active: Bool) -> Void, failure: () -> Void) {
        
        var url: String = "\(APIURL)/api/v1/suggestion/like"
        if (self.likeRequest != nil) {
            self.likeRequest.suspend()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.likeRequest = Alamofire.request(.GET, url, parameters: ["id": id])
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success(active: ((JSON?.objectForKey("status") as! String!) == "active"))
                }
        }
    }

    /**
     *  On click on main button
     */
    @IBAction func onTouchMainButton(sender: AnyObject) {
        self.onMainButton()
    }
}
