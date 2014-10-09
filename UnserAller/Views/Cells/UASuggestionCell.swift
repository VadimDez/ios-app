//
//  UASuggestionCell.swift
//  UnserAller
//
//  Created by Vadym on 09/10/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASuggestionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var suggestionId: UInt = 0
    var projectId: UInt = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellForHome(suggestion: UASuggestion) {
        
        self.contentLabel?.text     = suggestion.content
        self.titleLabel?.text       = suggestion.userName
        self.subtitleLabel?.text    = suggestion.projectName
        self.likeLabel?.text        = "\(suggestion.likeCount)"
        self.commentLabel?.text     = "\(suggestion.commentCount)"
        self.suggestionId           = suggestion.suggestionId
        self.projectId              = suggestion.projectId
        
        // date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        // set date
        self.dateLabel?.text = dateFormatter.stringFromDate(suggestion.updated)
        
    }

}
