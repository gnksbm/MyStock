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
    
    public override init() { }
    
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
                webSocketTask.cancel(
                    with: .goingAway,
                    reason: nil
                )
                timer.dispose()
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
        print("Socket Opened")
    }
    
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        print("Socket Closed")
    }
}
