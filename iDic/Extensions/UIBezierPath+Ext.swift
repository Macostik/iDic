//
//  UIBezierPath+Ext.swift
//  ContentViewerSwift
//
//  Created by Yura Granchenko on 6/16/17.
//  Copyright © 2017 Adviscent. All rights reserved.
//

import Foundation
import UIKit

func ^(lhs: CGFloat, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs, y: rhs)
}

func ^(lhs: CGFloat, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs, height: rhs)
}

func ^(lhs: CGPoint, rhs: CGSize) -> CGRect {
    return CGRect(origin: lhs, size: rhs)
}

extension UIBezierPath {
    
    @discardableResult func move(_ point: CGPoint) -> Self {
        self.move(to: point)
        return self
    }
    
    @discardableResult func line(_ point: CGPoint) -> Self {
        addLine(to: point)
        return self
    }
    
    @discardableResult func quadCurve(_ point: CGPoint, controlPoint: CGPoint) -> Self {
        addQuadCurve(to: point, controlPoint: controlPoint)
        return self
    }
}
