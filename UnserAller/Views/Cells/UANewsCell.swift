//
//  UANewsCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UANewsCell: UACell {
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    func setCellForHome(news: UANews) {
        self.titleLabel.text = news.projectName
        self.articleTitleLabel.text = news.title
        self.contentLabel.text = news.content
        self.subtitleLabel.text = ""
        self.dateLabel.text = news.updated.getStringFromDate()
        
        self.loadImage(self.mainImage, url: "\(APIURL)/api/v1/media/project/\(news.projectId)/40)/40")
        // make round corners
        self.makeRoundCorners()
    }
}
