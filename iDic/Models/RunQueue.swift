//
//  RunQueue.swift
//  iDic
//
//  Created by Yura Granchenko on 3/23/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import UIKit

typealias RunBlock = (_ finish: @escaping (() -> Void)) -> Void

final class RunQueue {
    
    static let entryFetchQueue = RunQueue(limit: 3)
    
    static let fetchQueue = RunQueue(limit: 1)
    
    private var blocks = [RunBlock]()
    
    private var executions = 0 {
        didSet {
            if executions == 0 && oldValue > 0 {
                didFinish?()
            } else if oldValue == 0 && executions > 0 {
                didStart?()
            }
        }
    }
    
    var isExecuting: Bool {
        return executions > 0
    }
    
    var didStart: (() -> Void)?
    
    var didFinish: (() -> Void)?
    
    var limit = 0
    
    convenience init(limit: Int) {
        self.init()
        self.limit = limit
    }
    
    private func _run(block: RunBlock) {
        block({
            if let block = self.blocks.first {
                _ = self.blocks.removeFirst()
                self._run(block: block)
            } else {
                self.executions -= 1
            }
        })
    }
    
    func run(block: @escaping RunBlock) {
        if limit == 0 || executions < limit {
            executions += 1
            _run(block: block)
        } else {
            blocks.append(block)
        }
    }
    
    func cancelAll() {
        blocks.removeAll()
    }
}
