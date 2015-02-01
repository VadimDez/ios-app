//
//  UASuggestionView.swift
//  UnserAller
//
//  Created by Vadim Dez on 15/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionView: UASuggestionHeaderView {

    func setUp(suggestion: UASuggestion) {
        self.suggestion = suggestion
        
        self.titleLabel.text = suggestion.userName
        self.subtitleLabel.text = suggestion.projectName
        self.contentLabel.text = suggestion.content
        self.likeLabel.text = "\(suggestion.likeCount)"
        self.commentLabel.text = "\(suggestion.commentCount)"
        
        self.adjustHeight(suggestion.content, imageQuantity: suggestion.media.count)
        self.makeRoundCorners()
        self.loadMainImage(suggestion.userId, width: 40, height: 40)
    }
}
