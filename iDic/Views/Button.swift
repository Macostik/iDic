//
//  Button.swift
//  ContentViewerSwift
//
//  Created by Yura Granchenko on 6/16/17.
//  Copyright © 2017 Adviscent. All rights reserved.
//

import Foundation
import UIKit

protocol Highlightable: class {
    var highlighted: Bool { get set }
}

protocol Selectable: class {
    var selected: Bool { get set }
}

extension UIControl: Highlightable, Selectable {}

extension UILabel: Highlightable, Selectable {
    var selected: Bool {
        get { return isHighlighted }
        set { isHighlighted = newValue }
    }
}

class Button : UIButton {
    
    convenience init(icon: String, font: UIFont = UIFont.systemFont(ofSize: 17.0), size: CGFloat = UIFont.systemFontSize, textColor: UIColor = UIColor.black) {
        self.init()
        titleLabel?.font = UIFont.iDic(size)
        setTitle(icon, for: .normal)
        setTitleColor(textColor, for: .normal)
    }
    
    static let minTouchSize: CGFloat = 44.0
    
    var animated: Bool = false
    var spinner: UIActivityIndicatorView?
    private var localizeID: String? = ""
    private var fontSize: CGFloat = 16.0
    
    @IBOutlet var highlightings: [UIView] = []
    @IBOutlet var selectings: [UIView] = []
    
    
    @IBInspectable var insets: CGSize = CGSize.zero
    @IBInspectable var spinnerColor: UIColor?
    
    @IBInspectable lazy var normalColor: UIColor = self.backgroundColor ?? UIColor.clear
    @IBInspectable lazy var highlightedColor: UIColor = self.defaultHighlightedColor()
    @IBInspectable lazy var selectedColor: UIColor = self.backgroundColor ?? UIColor.clear
    @IBInspectable lazy var disabledColor: UIColor = self.backgroundColor ?? UIColor.clear
    
    @IBInspectable var localize: Bool = false {
        willSet {
            if newValue == true {
                localizeID = title(for: UIControlState())
                fontSize = titleLabel?.font.pointSize ?? 16.0
                setTitle(localizeID?.ls ?? "", for: UIControlState())
            }
        }
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
    
    @IBInspectable var touchArea: CGSize = CGSize(width: minTouchSize, height: minTouchSize)
    
    var loading: Bool = false {
        willSet {
            if loading != newValue {
                if newValue == true {
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
                    spinner.color = spinnerColor ?? titleColor(for: UIControlState())
                    var spinnerSuperView: UIView = self
                    let contentWidth = sizeThatFits(size).width
                    if (self.width - contentWidth) < spinner.width {
                        if let superView = self.superview {
                            spinnerSuperView = superView
                        }
                        spinner.center = center
                        alpha = 0
                    } else {
                        let size = bounds.size
                        spinner.center = CGPoint(x: size.width - size.height/2, y: size.height/2)
                    }
                    spinnerSuperView.addSubview(spinner)
                    spinner.startAnimating()
                    self.spinner = spinner
                    isUserInteractionEnabled = false
                } else {
                    if spinner?.superview != self {
                        alpha = 1
                    }
                    spinner?.removeFromSuperview()
                    isUserInteractionEnabled = true
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            update()
            highlightings.forEach({ ($0 as? Highlightable)?.highlighted = isHighlighted })
        }
    }
    
    override var isSelected: Bool {
        didSet {
            update()
            selectings.forEach({ ($0 as? Selectable)?.selected = isSelected })
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            update()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }
    
    func defaultHighlightedColor() -> UIColor {
        return self.backgroundColor ?? UIColor.clear
    }
    
    func update() {
        let normalColor = self.normalColor
        let selectedColor = self.selectedColor
        let highlightedColor = self.highlightedColor
        let disabledColor = self.disabledColor
        var backgroundColor: UIColor = disabledColor
        if isEnabled {
            if isHighlighted {
                backgroundColor = highlightedColor
            } else {
                backgroundColor = isSelected ? selectedColor : normalColor
            }
        }
        if !(backgroundColor.isEqual(self.backgroundColor)) {
            setBackgroundColor(backgroundColor: backgroundColor, animated: animated)
        }
    }
    
    override var intrinsicContentSize : CGSize {
        let intrinsicSize = super.intrinsicContentSize
        return CGSize(width: intrinsicSize.width + insets.width, height: intrinsicSize.height + insets.height)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var rect = bounds
        rect = rect.insetBy(dx: -max(0, touchArea.width - rect.width)/2, dy: -max(0, touchArea.height - rect.height)/2)
        return rect.contains(point)
    }
    
    fileprivate var clickHelper: ObjectBlock? = nil
    
    func click(_ clickHelper: @escaping ObjectBlock) {
        self.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        self.clickHelper = clickHelper
    }
    
    func performAction() {
        clickHelper?(self)
    }
}

class SegmentButton: Button {
    
    override var isHighlighted: Bool {
        set { }
        get {
            return super.isHighlighted
        }
    }
}

class PressButton: Button {
    
    override func defaultHighlightedColor() -> UIColor {
        return normalColor.withAlphaComponent(0.1)
    }
}

extension UIButton {
    
    var active: Bool {
        set { setActive(active: newValue, animated: false) }
        get { return alpha > 0.5 && isUserInteractionEnabled }
    }
    
    func setActive(active: Bool, animated: Bool) {
        setAlpha(alpha: active ? 1.0 : 0.5, animated: animated)
        isUserInteractionEnabled = active
    }
    
    func addTarget(target: AnyObject?, touchUpInside: Selector) {
        addTarget(target, action: touchUpInside, for: .touchUpInside)
    }
}
