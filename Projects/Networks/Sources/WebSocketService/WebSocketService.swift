//
//  WebSocketService.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol WebSocketService {
    func openSocket(
        endPoint: WSEndPoint,
        dataToSend: Data
    ) -> Observable<(String?, Data?)>
}
