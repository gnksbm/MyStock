//
//  DefaultKISRealTimePriceRepository.swift
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

public final class DefaultKISRealTimePriceRepository
: KISRealTimePriceRepository {
    @Injected private var wsService: WebSocketService
    private let disposeBag = DisposeBag()
    
    public let price = PublishSubject<String>()
    
    public init() { }
    
    public func fetchRealTimePrice(
        request: KISRealTimePriceRequest
    ) -> Observable<String> {
        let endPoint = KISRealTimePriceEndPoint(
            approvalKey: request.approvalKey,
            ticker: request.ticker,
            investType: request.investType,
            marketType: request.marketType
        )
        do {
            let data = try endPoint.dataToSend()
            return wsService.openSocket(endPoint: endPoint, dataToSend: data)
                .flatMap { message in
                    let str = message.0
                    if let str {
                        if str.first == "{" {
                            if let data = str.data(using: .utf8),
                               let response = try? JSONDecoder().decode(
                                KISRealTimeStatusDTO.self,
                                from: data
                               ) {
                                let iv = response.body.output.iv
                                let key = response.body.output.key
                                AES256Manager.configAES(iv: iv, key: key)
                            }
                        } else {
                            guard let price = str
                                .split(separator: "|")
                                .last?
                                .split(separator: "^")[2]
                            else {
                                return Observable<String>.empty()
                            }
                            return Observable<String>.just(String(price))
                        }
                    }
                    return Observable<String>.empty()
                }
        } catch {
            return .error(error)
        }
    }
}
