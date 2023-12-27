//
//  NetworkService.swift
//  Data
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol NetworkService {
    func send(endPoint: EndPoint) -> Observable<Data>
}
