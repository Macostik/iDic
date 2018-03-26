//  
//  ChatViewController.swift
//  iDic
//
//  Created by Yura Granchenko on 3/21/18.
//  Copyright © 2018 Yura Granchenko. All rights

import UIKit
import RxSwift
import RxCocoa
import StreamView
import SwiftyJSON

class ChatViewController: BaseViewController, StoryboardBased, ViewModelBased,
UIScrollViewDelegate, StreamViewDataSource {
    
    
    typealias ViewModel = ChatViewModel
    var viewModel: ViewModel?
    private let disposeBag = DisposeBag()
    
    var messages = [Message]() {
        willSet {
            messages = newValue
            self.streamView.reload()
        }
    }
    
    let streamView = StreamView()
    
    private var messageMetrics = StreamMetrics<MessageCell>().change(initializer: { $0.selectable = false })
    private var myMessageMetrics = StreamMetrics<MyMessageCell>().change(initializer: { $0.selectable = false })
    private var messageWithNameMetrics = StreamMetrics<MessageWithNameCell>().change(initializer: { $0.selectable = false })
    
    private var dragged = false
    
    private var runQueue = RunQueue(limit: 1)
    
    func applicationDidBecomeActive() {
        streamView.reload()
    }
    
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.lightGray
        
        streamView.alwaysBounceVertical = true
        streamView.delegate = self
        streamView.dataSource = self
        view.add(streamView) { (make) in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        let firstMessage = Message()
        firstMessage.name = "Yura"
        firstMessage.text = "First message"
        insertMessage(message: firstMessage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageWithNameMetrics.modifyItem = { [weak self] item in
            guard let message = item.entry as? Message else { return }
            item.size = message.text.heightWithFont(UIFont.systemFont(ofSize: 17.0), width: UIScreen.main.bounds.width) + 24
            item.insets.size.height = 10
        }
        messageMetrics.modifyItem = messageWithNameMetrics.modifyItem
        myMessageMetrics.modifyItem = messageWithNameMetrics.modifyItem
        
        setupSocket()
    }
    
    private func setupSocket() {
        let socket = SocketManager.default.socket
        
        socket.on("connect") {data, ack in
            print("connect")
            
            socket.emitWithAck("add user", ["name": "Swift"]).timingOut(after: 0) {data in
                socket.emit("text", ["msg": "Hello from Swift!!!"])
            }
        }
        
        socket.on("joined") {data, ack in
            print("joined", data)
        }
        
        socket.on("add user") {data, ack in
            print("add user", data)
        }
        
        socket.on("error") {data, ack in
            print("error", data)
        }
        
        socket.on("text") {data, ack in
            print("text", data)
        }
        
        socket.on("newMessage") { [unowned self] data, ack in
            let text = JSON(data).arrayValue.first!["message"].stringValue
            let newMessage = Message()
            newMessage.text = text
            self.insertMessage(message: newMessage)
        }
        
        socket.connect()
    }
    
    private var topViewsHidden = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topViewsHidden = false
        streamView.width = view.width
        streamView.unlock()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        streamView.lock()
    }
    
    func insertMessage(message: Message) {
        if streamView.locked {
            self.messages.append(message)
            return
        }
        
        runQueue.run { [weak self] (finish) -> Void in
            guard let _self = self else {
                finish()
                return
            }
            let streamView = _self.streamView
            self?.messages.append(message)
            let offset = streamView.contentOffset.y
            let maxOffset = streamView.maximumContentOffset.y
            if !streamView.scrollable || maxOffset - offset > 5 {
                finish()
            } else {
                streamView.contentOffset.y = maxOffset - 70
                streamView.setMaximumContentOffsetAnimated(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    finish()
                })
            }
        }
    }
    
    private func appendItemsIfNeededWithTargetContentOffset(targetContentOffset: CGPoint) {
        let sv = self.streamView
        let reachedRequiredOffset =
            (targetContentOffset.y - sv.minimumContentOffset.y) < sv.fittingContentHeight
    }
    
    // MARK: - StreamViewDataSource
   
    func numberOfSections() -> Int { return 1 }
    func didLayoutItem(item: StreamItem) { }
    func didLayout() { }
    func headerMetricsIn(section: Int) -> [StreamMetricsProtocol] { return [] }
    func footerMetricsIn(section: Int) -> [StreamMetricsProtocol] { return [] }
    
    func numberOfItemsIn(section: Int) -> Int {
        return messages.count
    }
    
    func entryBlockForItem(item: StreamItem) -> ((StreamItem) -> Any?)? {
        return { [weak self] item in
            return self?.messages[safe: item.position.index]
        }
    }
    
    func metricsAt(position: StreamPosition) -> [StreamMetricsProtocol] {
        var metrics = [StreamMetricsProtocol]()
        guard let message = self.messages[safe: position.index] else { return metrics }
        if message.name == "Yura" {
            metrics.append(myMessageMetrics)
        } else {
            metrics.append(messageMetrics)
        }
        return metrics
    }
    
    func didChangeContentSize(oldContentSize: CGSize) {
        if streamView.scrollable {
            if dragged {
                let offset = streamView.contentSize.height - oldContentSize.height
                if offset > 0 {
                    streamView.contentOffset.y += offset
                }
            } else {
                streamView.contentOffset = streamView.maximumContentOffset
            }
        }
        appendItemsIfNeededWithTargetContentOffset(targetContentOffset: streamView.contentOffset)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragged = true
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        appendItemsIfNeededWithTargetContentOffset(targetContentOffset: targetContentOffset.pointee)
    }
    
    // MARK: - ComposeBarDelegate
    
    private func sendMessageWithText(text: String) {
        streamView.contentOffset = streamView.maximumContentOffset
    }
}
