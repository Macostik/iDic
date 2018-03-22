//
//  MessageCell.swift
//  iDic
//
//  Created by Yura Granchenko on 3/22/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import Foundation
import MobileCoreServices
import SnapKit
import StreamView

class Message {
    var text: String = ""
}

extension UIBezierPath {
    
    func addRoundedRect(rect: CGRect, corners: [CGFloat]) {
        guard corners.count == 4 else { return }
        let topLeft = corners[0]
        let topRight = corners[1]
        let bottomRight = corners[2]
        let bottomLeft = corners[3]
        let maxX = rect.maxX
        let maxY = rect.maxY
        let x = rect.origin.x
        let pi = CGFloat.pi
        if topLeft == 0 {
            move(0 ^ 0)
        } else {
            addArc(withCenter: (x + topLeft) ^ (rect.origin.y + topLeft),
                   radius: topLeft,
                   startAngle: pi,
                   endAngle: pi * 1.5, clockwise: true)
        }
        if topRight == 0 {
            line(maxX ^ 0)
        } else {
            line((maxX - topRight) ^ 0)
            addArc(withCenter: (maxX - topRight) ^ topRight,
                   radius: topRight,
                   startAngle: pi * 1.5,
                   endAngle: 0, clockwise: true)
        }
        if bottomRight == 0 {
            line(maxX ^ maxY)
        } else {
            line(maxX ^ (maxY - bottomRight))
            addArc(withCenter: (maxX - bottomRight) ^ (maxY - bottomRight),
                   radius: bottomRight,
                   startAngle: 0,
                   endAngle: pi * 0.5,
                   clockwise: true)
        }
        if bottomLeft == 0 {
            line(0 ^ maxY)
        } else {
            line((x + bottomLeft) ^ maxY)
            addArc(withCenter: (x + bottomLeft) ^ (maxY - bottomLeft),
                   radius: bottomLeft,
                   startAngle: pi * 0.5,
                   endAngle: pi,
                   clockwise: true)
        }
        close()
    }
}

final class MessageBubbleView: UIView {
    
    var isGroup = false
    var isGroupEnd = false
    var containsName = false
    
    var isRightSide = false
    
    var fillColor: UIColor?
    var strokeColor: UIColor?
    
    private func corners() -> [CGFloat] {
        if isGroup {
            if isGroupEnd {
                if containsName {
                    return [0, 14, 14, 14]
                } else {
                    return [14, 14, 14, 14]
                }
            } else {
                if containsName {
                    return [0, 14, 14, 3]
                } else {
                    return [14, 14, 3, 14]
                }
            }
        } else if isGroupEnd {
            return isRightSide ? [14, 3, 14, 14] : [3, 14, 14, 14]
        } else {
            return isRightSide ? [14, 3, 3, 14] : [3, 14, 14, 3]
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let lineWidth: CGFloat = 1/UIScreen.main.scale
        let path = UIBezierPath()
        path.addRoundedRect(rect: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2), corners: corners())
        
        if let fillColor = fillColor {
            fillColor.setFill()
            path.fill()
        }
        if let strokeColor = strokeColor {
            path.lineWidth = lineWidth
            strokeColor.setStroke()
            path.stroke()
        }
    }
}

class BaseMessageCell: EntryStreamReusableView<Message> {
    
    internal let timeLabel = Label()
    internal let textView = UITextView()
    internal let bubbleView = specify(MessageBubbleView(), {
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.clear
    })
    
    override func setup(entry message: Message) {
        setupMessage(message: message)
    }
    
    internal func setupMessage(message: Message) {
        textView.text = message.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bubbleView.setNeedsDisplay()
    }
}

final class MessageCell: BaseMessageCell {
    
    override func layoutWithMetrics(metrics: StreamMetricsProtocol) {
        super.layoutWithMetrics(metrics: metrics)
        bubbleView.strokeColor = UIColor.red
        bubbleView.fillColor = UIColor.white
        add(bubbleView) { (make) -> Void in
            make.leading.equalTo(self).offset(64)
            make.trailing.lessThanOrEqualTo(self).offset(-64)
            make.top.equalTo(self)
            make.width.greaterThanOrEqualTo(50)
        }
        bubbleView.add(textView) { (make) -> Void in
            make.top.equalTo(bubbleView).offset(12)
            make.leading.equalTo(bubbleView).offset(16)
            make.trailing.equalTo(bubbleView).offset(-16)
            make.bottom.equalTo(bubbleView).offset(-12)
        }
        add(timeLabel) { (make) -> Void in
            make.leading.equalTo(bubbleView.snp.trailing).offset(12)
            make.centerY.equalTo(bubbleView)
        }
    }
}

final class MessageWithNameCell: BaseMessageCell {
    
    private let nameLabel = Label()
    
    override func layoutWithMetrics(metrics: StreamMetricsProtocol) {
        super.layoutWithMetrics(metrics: metrics)
        bubbleView.strokeColor = UIColor.red
        bubbleView.fillColor = UIColor.white
        
        add(bubbleView) { (make) -> Void in
            make.leading.equalTo(self).offset(64)
            make.trailing.lessThanOrEqualTo(self).offset(-64)
            make.top.equalTo(self)
            make.width.greaterThanOrEqualTo(50)
        }
        
        bubbleView.add(nameLabel) { (make) -> Void in
            make.leading.equalTo(bubbleView).offset(16)
            make.trailing.lessThanOrEqualTo(bubbleView).offset(-16)
            make.top.equalTo(bubbleView).offset(12)
        }
        
        bubbleView.add(textView) { (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(bubbleView).offset(16)
            make.trailing.equalTo(bubbleView).offset(-16)
            make.bottom.equalTo(bubbleView).offset(-12)
        }
        add(timeLabel) { (make) -> Void in
            make.leading.equalTo(bubbleView.snp.trailing).offset(12)
            make.centerY.equalTo(bubbleView)
        }
    }
    
    override func setupMessage(message: Message) {
        super.setupMessage(message: message)
        nameLabel.text = message.text
    }
}

final class MyMessageCell: BaseMessageCell {
    
    override func layoutWithMetrics(metrics: StreamMetricsProtocol) {
        super.layoutWithMetrics(metrics: metrics)
        bubbleView.fillColor = UIColor.orange
        bubbleView.isRightSide = true
        textView.textColor = UIColor.white
        add(bubbleView) { (make) -> Void in
            make.trailing.equalTo(self).offset(-24)
            make.leading.greaterThanOrEqualTo(self).offset(64)
            make.top.equalTo(self)
            make.width.greaterThanOrEqualTo(50)
        }
        bubbleView.add(textView) { (make) -> Void in
            make.top.equalTo(bubbleView).offset(12)
            make.leading.equalTo(bubbleView).offset(16)
            make.trailing.equalTo(bubbleView).offset(-16)
            make.bottom.equalTo(bubbleView).offset(-12)
        }
        add(timeLabel) { (make) -> Void in
            make.trailing.equalTo(bubbleView.snp.leading).offset(-12)
            make.centerY.equalTo(bubbleView)
        }
    }
}
