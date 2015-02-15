//
//  UACreditCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 16/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UACreditCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(credit: UACredit) {
        self.projectName.text = credit.project.name
        self.totalCount.text = "\(credit.totalCredits)"
    }
}
