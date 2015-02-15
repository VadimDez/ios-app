//
//  UAProjectNewsCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAProjectNewsCell: UACell {

    func setCellForProjectPhase(news: UANews) {
        self.contentLabel.text  = news.content
        self.titleLabel.text    = news.title
        self.dateLabel.text     = news.created
    }
}
