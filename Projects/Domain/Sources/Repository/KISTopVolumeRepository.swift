//
//  KISTopVolumeRepository.swift
//  Domain
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol KISTopVolumeRepository {
    func fetchTopVolumeItems(
        request: KISTopVolumeRequest
    ) -> Observable<[KISTopVolumeResponse]>
}
