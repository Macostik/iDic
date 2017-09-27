//
//  PlaceholderView.swift
//  StreamView
//
//  Created by Yura Granchenko on 4/20/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation


public class PlaceholderView: UIView {
    
    static public func placeholderView(iconName: String, message: String, color: UIColor = UIColor.lightGray) -> (() -> PlaceholderView) {
        return {
            let view = PlaceholderView()
            view.isUserInteractionEnabled = false
            view.addSubview(view.textLabel)
            view.addSubview(view.iconLabel)
            view.textLabel.contentMode = .center
            view.iconLabel.contentMode = .center
            view.iconLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
            view.textLabel.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
            view.textLabel.textColor = color
            view.iconLabel.textColor = color
            view.textLabel.text = message
            view.iconLabel.text = iconName
            return view
        }
    }
    
    public let textLabel = specify(object: UILabel(icon: "", textColor: UIColor.lightGray)) {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    public let iconLabel = UILabel(icon: "", size: 96, textColor: UIColor.lightGray)
    
    public func layoutInStreamView(streamView: StreamView) {
        streamView.add(self)
        self.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
    }
}

extension UILabel {
    convenience public init(icon: String, font: UIFont = UIFont.systemFont(ofSize: 17.0), size: CGFloat = UIFont.systemFontSize, textColor: UIColor = UIColor.white) {
        self.init()
        self.font = font
        text = icon
        self.textColor = textColor
    }
}
