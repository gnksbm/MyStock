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
    func request(endPoint: RestfulEndPoint) -> Observable<Data>
    func requestWithCache(endPoint: RestfulEndPoint) -> Observable<Data>
}
