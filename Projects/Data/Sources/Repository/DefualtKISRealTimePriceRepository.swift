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
    
    let receivedMessage = PublishSubject<(String?, Data?)>()
    
    public init(wsService: WebSocketService) {
        self.wsService = wsService
    }
    
    public func requestData(request: KISRealTimePriceRequest) {
//        let endPoint = KISRealTimePriceEndPoint(
//            approvalKey: request.approvalKey,
//            ticker: request.ticker,
//            investType: request.investType,
//            marketType: request.marketType
//        )
        let endPoint = KISRealTimePriceEndPoint(
            approvalKey: request.approvalKey,
            ticker: "DNASAAPL",
            investType: request.investType,
            marketType: .overseas
        )
        
        wsService.open(endPoint: endPoint)
        guard let data = endPoint.requestJson else {
            print("\nBad Request\n")
            return
        }
        wsService.send(data)
        
        wsService.receivedMessage.subscribe(
            onNext: { str, data in
                if let str {
                    if let data = str.data(using: .utf8),
                       let response = try? JSONDecoder().decode(
                        KISRealTimePriceDTO.self,
                        from: data
                       ) {
                        let iv = response.body.output.iv
                        let key = response.body.output.key
                        AES256.configAES(iv: iv, key: key)
                        print(str)
                    } else {
                        print(str)
                        guard let encoded = str.split(
                            separator: "DNASAAPL"
                        ).last
                        else { return }
                        do {
                            let encoded = encoded.split(separator: "^")
                                .joined(separator: " ")
                            let result = try AES256.decrypt(
                                encoded: "DNASAAPL\(encoded)"
                            )
                            print(result)
                        } catch {
                            print(error)
                        }
                    }
                }
                if let data {
                    print(data.description)
                }
            }
        )
        .disposed(by: disposeBag)
    }
}
