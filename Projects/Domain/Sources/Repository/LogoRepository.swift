//
//  LogoRepository.swift
//  Domain
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import RxSwift

public protocol LogoRepository {
    func fetchLogo(
        request: LogoRequest
    ) -> Observable<LogoResponse>
    
    func updateLogo<T: LogoRequestable>(
        from: T,
        request: LogoRequest
    ) -> Observable<T>
}
