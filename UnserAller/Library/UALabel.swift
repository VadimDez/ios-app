//
//  UALabel.swift
//  UnserAller
//
//  Created by Vadim Dez on 10/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UALabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (self.numberOfLines == 0) {
            // If this is a multiline label, need to make sure
            // preferredMaxLayoutWidth always matches the frame width
            // (i.e. orientation change can mess this up)
        
            if (self.preferredMaxLayoutWidth != self.frame.size.width) {
                self.preferredMaxLayoutWidth = self.frame.size.width
                self.setNeedsUpdateConstraints()
            }
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size: CGSize = super.intrinsicContentSize()
        
        if (self.numberOfLines == 0) {
            // There's a bug where intrinsic content size
            // may be 1 point too short
            size.height += 1
        }
        
        return size
    }

}
