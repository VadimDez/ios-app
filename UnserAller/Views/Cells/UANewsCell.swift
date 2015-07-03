//
//  UANewsCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UANewsCell: UACell {
    
    func setCellForHome(news: UANews) {
        self.titleLabel.text = news.projectName
        self.contentLabel.text = news.content
        self.subtitleLabel.text = ""
        self.dateLabel.text = news.updated.getStringFromDate()
        
        // make round corners
//        self.makeRoundCorners()
    }
}
