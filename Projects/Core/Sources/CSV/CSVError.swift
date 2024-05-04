//
//  CSVError.swift
//  Core
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public enum CSVError: LocalizedError {
    case invalidURL(String)
    case invalidData
    case parseError
    
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case .invalidURL(let fileName):
            return "\(fileName): 유효하지 않은 URL입니다."
        case .parseError:
            return "데이터 파싱에 실패하였습니다."
        }
    }
}
