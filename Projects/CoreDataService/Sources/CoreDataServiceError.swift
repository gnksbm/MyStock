//
//  CoreDataServiceError.swift
//  CoreDataService
//
//  Created by gnksbm on 5/4/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

enum CoreDataServiceError: LocalizedError {
    case notUnique, invalidData, unAlteredData
    
    var errorDescription: String? {
        switch self {
        case .notUnique:
            return "중복된 데이터 저장입니다."
        case .invalidData:
            return "찾을 수 없는 데이터입니다."
        case .unAlteredData:
            return "수정되지 않은 데이터입니다."
        }
    }
}
