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

        self.loadProjectImage(project.id)
    }
    
    /**
     * Load project image
     */
    func loadProjectImage(projectId: UInt) {
        
        let width = UInt(self.projectImage.frame.width)
        let height = UInt(self.projectImage.frame.height)

        // load profile image
        let request = NSURLRequest(URL: NSURL(string: "\(APIURL)/api/v1/media/project/\(projectId)/height/\(height)/width/\(width)")!)
        self.projectImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            
            if let weakSelf = self {
                weakSelf.projectImage.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
                
        }
    }
}
