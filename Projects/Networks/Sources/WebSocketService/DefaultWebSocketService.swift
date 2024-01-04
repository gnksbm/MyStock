//
//  DefaultWebSocketService.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultWebSocketService: NSObject, WebSocketService {
    private var webSocketTask: URLSessionWebSocketTask?
    private var timer: Timer?
    private var disposeBag = DisposeBag()
    
    public let receivedMessage = PublishSubject<(String?, Data?)>()
    public let didOpenWith = { }
    public let didCloesWith = { }
    
    public override init() { }
    
    deinit {
        print("deinit")
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let str):
                    self?.receivedMessage.onNext((str, nil))
                case .data(let data):
                    self?.receivedMessage.onNext((nil, data))
                @unknown default:
                    self?.receivedMessage.onError(WebSocketError.unknownMessage)
                }
            case .failure(let error):
                self?.receivedMessage.onError(error)
            }
            self?.receive()
        }
    }
    
    public func open(endPoint: WSEndPoint) {
        guard let urlRequest = endPoint.toURLRequest
        else {
            receivedMessage.onError(WebSocketError.invalidURL)
            return
        }
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        webSocketTask = session.webSocketTask(with: urlRequest)
        webSocketTask?.resume()
        receive()
        startPing()
    }
    
    public func close() {
        self.webSocketTask = nil
        self.timer?.invalidate()
    }
    
    public func send(_ str: String) {
        let message = URLSessionWebSocketTask.Message.string(str)
        webSocketTask?.send(message) { [weak self] error in
            if let error {
                self?.receivedMessage.onError(error)
            }
        }
    }
    
    public func send(_ data: Data) {
        let message = URLSessionWebSocketTask.Message.data(data)
        webSocketTask?.send(message) { [weak self] error in
            if let error {
                self?.receivedMessage.onError(error)
            }
        }
    }
    
    private func startPing() {
        timer?.invalidate()
        timer = .scheduledTimer(
            withTimeInterval: 10,
            repeats: true,
            block: { [weak self] _ in
                self?.ping()
            }
        )
    }
    
    private func ping() {
        webSocketTask?.sendPing { [weak self] error in
            if let error {
                print("Ping failed: \(error.localizedDescription)")
                self?.startPing()
            }
        }
    }
}

extension DefaultWebSocketService: URLSessionWebSocketDelegate {
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        print("open")
        didOpenWith()
    }
    
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        didCloesWith()
    }
}
