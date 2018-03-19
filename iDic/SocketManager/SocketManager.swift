//
//  SocketManager.swift
//  iDic
//
//  Created by Yura Granchenko on 3/19/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import Foundation
import SocketIO

open class SocketManager {
    open static let `default` = SocketManager()
    lazy var socket: SocketIOClient = { return self.manager.defaultSocket }()
    private let manager = SocketIO.SocketManager(socketURL: URL(string: "https://idic.herokuapp.com")!,
                                                 config: [.reconnects(true)])
}
