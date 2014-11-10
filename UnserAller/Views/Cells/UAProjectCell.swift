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
    
    func setCell(project: UAProject) {
        label.text = project.name
    }
}
