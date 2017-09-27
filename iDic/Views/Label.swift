//
//  Label.swift
//  ContentViewerSwift
//
//  Created by Yura Granchenko on 6/16/17.
//  Copyright © 2017 Adviscent. All rights reserved.
//

import Foundation
import UIKit

class Label: UILabel {
    
    private var localizeID: String? = ""
    private var fontSize: CGFloat = 16.0
    private var _isUpperCased = false
    
    convenience init(icon: String, font: UIFont = UIFont.systemFont(ofSize: 17.0), size: CGFloat = UIFont.systemFontSize, textColor: UIColor = UIColor.black) {
        self.init()
        self.font = UIFont.iDic(size)
        self.text = icon
        self.textColor = textColor
    }
    
    @IBInspectable var localize: Bool = false {
        willSet {
            if newValue {
                localizeID = text
                text = text?.ls
                fontSize = font.pointSize
            }
        }
    }
    
    @IBInspectable var isUpperCased: Bool = false {
        willSet {
            if newValue {
                _isUpperCased = newValue
                text = text?.uppercased()
            }
        }
    }
    
    @IBInspectable var insets: CGSize = CGSize.zero
    
    override open var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize.init(width: size.width + insets.width, height: size.height + insets.height)
    }
    
    @IBInspectable var rotate: Bool = false {
        willSet {
            if newValue == true {
                switch contentMode {
                case .bottom:
                    transform = CGAffineTransform(rotationAngle: .pi)
                case .left:
                    transform = CGAffineTransform(rotationAngle: -(.pi/2))
                case .right:
                    transform = CGAffineTransform(rotationAngle: .pi/2)
                default:
                    transform = CGAffineTransform.identity
                }
            }
        }
    }
}

final class BadgeLabel: Label {
    
    var value = 0 {
        willSet {
            text = String(newValue)
            isHidden = newValue == -1
            cornerRadius = height/2
            textAlignment = .center
            clipsToBounds = true
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size = CGSize.init(width:size.width + 15, height: size.height + 5)
        layer.cornerRadius = size.height/2
        return size
    }
}
