//
//  CompetenceCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACompetenceCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var competence: UACompetence!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func validate() {
        if !self.competence.validate() {
            self.contentLabel.backgroundColor = UIColor.yellowColor()
        } else {
            self.contentLabel.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func setupCell(competence: UACompetence) {
        
    }
}
