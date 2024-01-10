//
//  DefualtKISRealTimePriceRepository.swift
//  Data
//
//  Created by gnksbm on 2024/01/04.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

import RxSwift

public final class DefualtKISRealTimePriceRepository
: KISRealTimePriceRepository {
    private let wsService: WebSocketService
    private let disposeBag = DisposeBag()
    
    public let price = PublishSubject<String>()
    
    public init(wsService: WebSocketService) {
        self.wsService = wsService
    }
    
    public func requestData(request: KISRealTimePriceRequest) {
        let endPoint = KISRealTimePriceEndPoint(
            approvalKey: request.approvalKey,
            ticker: request.ticker,
            investType: request.investType,
            marketType: request.marketType
        )
        
        wsService.open(endPoint: endPoint)
        guard let data = endPoint.requestJson else {
            print("\nBad Request\n")
            return
        }
        wsService.send(data)
        
        wsService.receivedMessage
            .withUnretained(self)
            .subscribe(
            onNext: { repository, message in
                print(message)
                let str = message.0
                let data = message.1
                if let str {
                    if str.first == "{" {
                        if let data = str.data(using: .utf8),
                           let response = try? JSONDecoder().decode(
                            KISRealTimeStatusDTO.self,
                            from: data
                           ) {
                            let iv = response.body.output.iv
                            let key = response.body.output.key
                            AES256.configAES(iv: iv, key: key)
                        }
                    } else {
                        guard let price = str
                            .split(separator: "|")
                            .last?
                            .split(separator: "^")[2]
                        else { return }
                        repository.price.onNext(String(price))
                    }
                }
                if let data {
                    print(data.description)
                }
            }
        )
        .disposed(by: disposeBag)
    }
    
    public func disconnectSocket() {
        wsService.close()
    }
}
