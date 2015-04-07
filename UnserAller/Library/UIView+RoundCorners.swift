//
//  UIView+RoundCorners.swift
//  UnserAller
//
//  Created by Vadim Dez on 07/04/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

// HOW TO USE:
//
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
}