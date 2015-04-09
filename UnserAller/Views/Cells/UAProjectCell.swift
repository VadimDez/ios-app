//
//  UAProjectCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 10/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAProjectCell: UITableViewCell {

    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var companyName: UILabel!
    
    func setCell(project: UAProject) {
        self.label.text = project.name
        self.companyName.text = project.company.name
        
        self.loadProjectImage(project.imageUrl)
        
//        self.removeEffect()
//        self.addEffect()
    }
    
    func addEffect() {
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.projectImage.frame
        
        self.projectImage.addSubview(effectView)
    }
    
    func removeEffect() {
        for subView in self.projectImage.subviews {
            if subView.isKindOfClass(UIVisualEffectView) {
                subView.removeFromSuperview()
            }
        }
    }
    
    /**
     * Load project image
     */
    func loadProjectImage(url: String) {
        
        let width = UInt(self.projectImage.frame.width)
        let height = UInt(self.projectImage.frame.height)
        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "\(url)/height/\(height)/width/\(width)")!)
        self.projectImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            
            if let weakSelf = self {
                weakSelf.projectImage.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
    }
}
