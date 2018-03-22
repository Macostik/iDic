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

class ChatViewController: BaseViewController, StoryboardBased, ViewModelBased,
UIScrollViewDelegate, StreamViewDataSource {
    
    typealias ViewModel = ChatViewModel
    var viewModel: ViewModel?
    private let disposeBag = DisposeBag()
    
    weak var badge: BadgeLabel?
    
    let streamView = StreamView()
    
    let chat: Chat
    
    private var messageMetrics = StreamMetrics<MessageCell>().change({ $0.selectable = false })
    private var myMessageMetrics = StreamMetrics<MyMessageCell>().change({ $0.selectable = false })
    private var messageWithNameMetrics = StreamMetrics<MessageWithNameCell>().change({ $0.selectable = false })
    
    private var dragged = false
    
    private var runQueue = RunQueue(limit: 1)
    
    func applicationDidBecomeActive() {
        badge?.value = chat.unreadMessages.count
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageWithNameMetrics.modifyItem = { [weak self] item in
            guard let message = item.entry as? Message else { return }
            item.size = self?.chat.heightOfMessageCell(message) ?? 0.0
            item.insets.size.height = message.chatMetadata.isGroupEnd ? Chat.MessageGroupSpacing : Chat.MessageSpacing
        }
        messageMetrics.modifyItem = messageWithNameMetrics.modifyItem
        myMessageMetrics.modifyItem = messageWithNameMetrics.modifyItem
        
        chat.didChangeNotifier.subscribe(self) { [unowned self] (value) in
            self.streamView.reload()
        }
    }
    
    private var topViewsHidden = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topViewsHidden = false
        streamView.width = view.width
        streamView.unlock()
        chat.sort()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        streamView.lock()
        chat.markAsRead()
    }
    
    func insertMessage(message: Message) {
    if streamView.locked {
    chat.add(message)
    return
    }
    
    runQueue.run { [weak self] (finish) -> Void in
    guard let _self = self else {
    finish()
    return
    }
    let streamView = _self.streamView
    _self.chat.add(message)
    let offset = streamView.contentOffset.y
    let maxOffset = streamView.maximumContentOffset.y
    if message.contributor != User.currentUser {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    if !streamView.scrollable || maxOffset - offset > 5 {
    finish()
    } else {
    streamView.contentOffset.y = maxOffset - _self.chat.heightOfMessageCell(message)
    streamView.setMaximumContentOffsetAnimated(true)
    Dispatch.mainQueue.after(0.5, block:finish)
    }
    }
    }
    
    private func appendItemsIfNeededWithTargetContentOffset(targetContentOffset: CGPoint) {
        let sv = self.streamView
        let reachedRequiredOffset =
            (targetContentOffset.y - sv.minimumContentOffset.y) < sv.fittingContentHeight
    }
    
    // MARK: - StreamViewDataSource
    
    func numberOfItemsIn(section: Int) -> Int {
        return chat.entries.count
    }
    
    func entryBlockForItem(item: StreamItem) -> ((StreamItem) -> AnyObject?)? {
        return { [weak self] item in
            return self?.chat.entries[safe: item.position.index]
        }
    }
    
    func metricsAt(position: StreamPosition) -> [StreamMetricsProtocol] {
        var metrics = [StreamMetricsProtocol]()
        guard let message = chat.entries[safe: position.index] else { return metrics }
        if message.contributor?.current == true {
            metrics.append(myMessageMetrics)
        } else if message.chatMetadata.containsName {
            metrics.append(messageWithNameMetrics)
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
}
