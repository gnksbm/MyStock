//
//  KISOAuthDTO.swift
//  Data
//
//  Created by gnksbm on 5/6/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

protocol KISOAuthDTO {
    var toDomain: KISOAuthToken { get }
}
