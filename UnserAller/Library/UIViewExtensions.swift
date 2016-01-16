//
//  UIView+RoundCorners.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/04/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

// HOW TO USE:
//
//      roundCorners:
//        self.username.roundCorners(.TopLeft | .TopRight, radius: 7)
//        self.password.roundCorners(.BottomLeft | .BottomRight, radius: 7)
//
//

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }

    func layerGradient(color1: UIColor, color2: UIColor, color3: UIColor, color4: UIColor) {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPointMake(0.0, 0.0)
        
        layer.colors = [color1.CGColor, color2.CGColor, color3.CGColor, color4.CGColor]
        self.layer.insertSublayer(layer, atIndex: 0)
    }
}