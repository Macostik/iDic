//
//  TextView.swift
//  ContentViewerSwift
//
//  Created by Yura Granchenko on 6/20/17.
//  Copyright © 2017 Adviscent. All rights reserved.
//

import Foundation
import UIKit

class TextView: UITextView {
    
    @IBInspectable var trim: Bool = false
    private var localizeID: String? = ""
    private var fontSize: CGFloat = 16.0
    
    @IBInspectable var localize: Bool = false {
        willSet {
            if newValue {
                localizeID = text
                text = text?.ls
                fontSize = font?.pointSize ?? 16.0
            }
        }
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        awake()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        awake()
    }
    
    func awake() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        if isEditable && dataDetectorTypes != .none {
            dataDetectorTypes = .all
        }
    }
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    @objc final func textDidChange() {
        updatePlaceholder()
    }
    
    private lazy var placeholderLabel: UILabel = specify(UILabel()) { label in
        self.addSubview(label)
        label.frame = self.frame
    }
    
    private func updatePlaceholder() {
        if let placeholder = placeholder, text.isEmpty == false {
            placeholderLabel.text = placeholder
            placeholderLabel.isHidden = false
            placeholderLabel.font = font
            placeholderLabel.textColor = UIColor.lightGray
        } else {
            placeholderLabel.text = ""
            placeholderLabel.isHidden = true
        }
    }
    
    var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override func resignFirstResponder() -> Bool {
        if trim == true, let text = text, text.isEmpty == true {
            self.text = text.trim
        }
        
        return super.resignFirstResponder()
    }
}
