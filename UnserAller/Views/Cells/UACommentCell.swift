//
//  UACommentCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 18/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACommentCell: UACell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(comment: UAComment) {
        self.titleLabel?.text   = comment.user.fullName
        self.contentLabel?.text = comment.content
        self.dateLabel?.text    = self.getStringFromDate(comment.updated)
        
        self.makeRoundCorners()
        self.loadMainImage(comment.user.id, width: 35, height: 35)
    }
}
