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
        let imageLayer:CALayer = self.centerBox.layer;
        imageLayer.cornerRadius = 7
        imageLayer.masksToBounds = true
        
        self.hideLines(false)
        self.resetFont()
        print("in awake")
    }
    
    func setPhaseName(name: String) {
        self.phaseLabel.text = name
    }
    
    func firstElement () {
        self.hideLines(false)
        self.resetFont()
        
        self.leftLine.hidden = true
    }
    func lastElement () {
        self.hideLines(false)
        self.resetFont()
        
        self.rightLine.hidden = true
    }
    
    /**
     *  Set news cell
     */
    func setNewsCell() {
        self.setPhaseName("News")
        self.hideLines(true)
        self.resetFont()
    }

    
    func hideLines(hide: Bool) -> Void {
        self.leftLine.hidden = hide
        self.centerBox.hidden = hide
        self.rightLine.hidden = hide
    }
    
    func resetFont() {
        self.phaseLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
    }
    
    func setSelected() {
        self.phaseLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
    }
}
