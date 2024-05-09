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
    private var webSocketTask: URLSessionWebSocketTask? {
        didSet {
            oldValue?.cancel(with: .goingAway, reason: nil)
        }
    }
    
    private var timer: Timer?
    
    public let receivedMessage = PublishSubject<(String?, Data?)>()
    
    public override init() { }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            guard self?.webSocketTask != nil else { return }
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
                self?.receivedMessage.onError(WebSocketError.sendError(error))
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
    
    public func openSocket(
        endPoint: WSEndPoint,
        dataToSend: Data
    ) -> Observable<(String?, Data?)> {
        guard let urlRequest = endPoint.toURLRequest
        else {
            return .error(WebSocketError.invalidURL)
        }
        
        return Observable.create { [weak self] observer in
            let session = URLSession(
                configuration: .default,
                delegate: self,
                delegateQueue: OperationQueue()
            )
            let webSocketTask = session.webSocketTask(with: urlRequest)
            webSocketTask.resume()
            webSocketTask.send(.data(dataToSend)) { error in
                if let error {
                    observer.onError(error)
                }
            }
            let timer = Observable<Int>
                .interval(
                    .seconds(10),
                    scheduler: MainScheduler.asyncInstance
                )
                .subscribe(
                    onNext: { _ in
                        print("Ping: ", endPoint.toURLRequest?.url)
                        webSocketTask.sendPing { error in
                            if let error {
                                observer.onError(
                                    WebSocketError.pingError(error)
                                )
                            }
                        }
                    }
                )
            func receiveMessage() {
                webSocketTask.receive { result in
                    switch result {
                    case .success(let success):
                        switch success {
                        case .data(let data):
                            observer.onNext((nil, data))
                        case .string(let str):
                            observer.onNext((str, nil))
                        @unknown default:
                            observer.onError(WebSocketError.unknownMessage)
                        }
                        receiveMessage()
                    case .failure(let error):
                        observer.onError(WebSocketError.sendError(error))
                    }
                }
            }
            receiveMessage()
            return Disposables.create {
                webSocketTask.cancel()
                timer.dispose()
            }
        }
    }
    
    public func close() {
        webSocketTask = nil
        timer?.invalidate()
    }
    
    public func send(_ str: String) {
        let message = URLSessionWebSocketTask.Message.string(str)
        send(message: message)
    }
    
    public func send(_ data: Data) {
        let message = URLSessionWebSocketTask.Message.data(data)
        send(message: message)
    }
    
    private func send(message: URLSessionWebSocketTask.Message) {
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
    }
    
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        print("close")
    }
}
