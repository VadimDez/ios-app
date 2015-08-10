//
//  UAOptionCell.swift
//  UnserAller
//
//  Created by Vadym on 10/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAOptionCell: UITableViewCell {
    
    @IBOutlet weak var toggleView: UIImageView!
    @IBOutlet weak var label: UILabel!

    var toggled: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func toggle(isToggled: Bool) {
        self.toggled = isToggled
    }
}
