//
//  PhaseCell.swift
//  UnserAller
//
//  Created by Vadym on 30/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAPhaseCell: UICollectionViewCell {
    
    @IBOutlet weak var phaseLabel: UILabel!
    @IBOutlet weak var leftLine: UIImageView!
    @IBOutlet weak var centerBox: UIImageView!
    @IBOutlet weak var rightLine: UIImageView!
    
    override func awakeFromNib() {
        // make circle
        var imageLayer:CALayer = self.centerBox.layer;
        imageLayer.cornerRadius = 7
        imageLayer.masksToBounds = true
    }
    
    func setPhaseName(name: String) {
        self.phaseLabel.text = name
    }
    
    func firstElement () {
        self.leftLine.backgroundColor = UIColor.clearColor()
    }
    func lastElement () {
        self.rightLine.backgroundColor = UIColor.clearColor()
    }
    
    /**
     *  Set news cell
     */
    func setNewsCell() {
        self.setPhaseName("News")
        self.leftLine.hidden = true
        self.centerBox.hidden = true
        self.rightLine.hidden = true
    }

}
