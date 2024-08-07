//
//  KISQueryRepresentable.swift
//  Domain
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public protocol KISQueryRepresentable {
    var httpQuery: [String: String] { get }
}

/// 입력 종목코드
public enum KISInputISCode: KISQueryRepresentable {
    case all
    
    public var httpQuery: [String: String] {
        switch self {
        case .all:
            ["FID_INPUT_ISCD": "0000"]
        }
    }
    
    var description: String {
        switch self {
        case .all:
            "전체"
        }
    }
}

/// 분류 구분 코드
public enum KISDivisionCode: Int, KISQueryRepresentable {
    case all, common, preferred
    
    public var httpQuery: [String: String] {
        ["FID_DIV_CLS_CODE": "\(rawValue)"]
    }
    
    var description: String {
        switch self {
        case .all:
            "전체"
        case .common:
            "보통주"
        case .preferred:
            "우선주"
        }
    }
}

/// 소속 구분 코드
public enum KISBelongingClassCode: Int, KISQueryRepresentable {
    case averageVolume
    case volumeGrowthRate
    case averageTurnoverRate
    case volumeRanking
    case averageTurnoverValue
    
    public var httpQuery: [String: String] {
        ["FID_BLNG_CLS_CODE": "\(rawValue)"]
    }
    
    var description: String {
        switch self {
        case .averageVolume:
            return "평균거래량"
        case .volumeGrowthRate:
            return "거래증가율"
        case .averageTurnoverRate:
            return "평균거래회전율"
        case .volumeRanking:
            return "거래금액순"
        case .averageTurnoverValue:
            return "평균거래금액회전율"
        }
    }
}

/// 대상 구분 코드
public enum KISTargetClassCode: String, KISQueryRepresentable {
    case margin = "111111111"
    case credit = "000000000"
    
    public var httpQuery: [String: String] {
        ["FID_TRGT_CLS_CODE": rawValue]
    }
    
    var description: String {
        switch self {
        case .margin:
            "증거금"
        case .credit:
            "신용보증금"
        }
    }
}

/// 대상 제외 구분 코드
public enum KISTargetExcludeClassCode: String, KISQueryRepresentable {
    case investmentRisk = "0000000000"
    case warning = "0000000001"
    case management = "0000000010"
    case liquidation = "0000000100"
    case unfaithfulDisclosure = "0000001000"
    case preferredStock = "0000010000"
    case tradingSuspension = "0000100000"
    case etf = "0001000000"
    case etn = "0010000000"
    case creditOrderNotAllowed = "0100000000"
    case spac = "1000000000"
    
    public var httpQuery: [String: String] {
        ["FID_TRGT_EXLS_CLS_CODE": rawValue]
    }
    
    var description: String {
        switch self {
        case .investmentRisk:
            return "투자위험"
        case .warning:
            return "경고"
        case .management:
            return "관리종목"
        case .liquidation:
            return "정리매매"
        case .unfaithfulDisclosure:
            return "불성실공시"
        case .preferredStock:
            return "우선주"
        case .tradingSuspension:
            return "거래정지"
        case .etf:
            return "ETF"
        case .etn:
            return "ETN"
        case .creditOrderNotAllowed:
            return "신용주문불가"
        case .spac:
            return "SPAC"
        }
    }
}

/// 입력 가격
public enum KISInputPrice: KISQueryRepresentable {
    case all
    case range(from: String, to: String)
    
    public var httpQuery: [String: String] {
        var result = [
            "FID_INPUT_PRICE_1": "",
            "FID_INPUT_PRICE_2": ""
        ]
        switch self {
        case .all:
            break
        case .range(let from, let to):
            result["FID_INPUT_PRICE_1"] = from
            result["FID_INPUT_PRICE_2"] = to
        }
        return result
    }
    
    var description: (String, String) {
        switch self {
        case .range(let from, let to):
            return (from, to)
        case .all:
            return ("", "")
        }
    }
}

/// 거래량 수
public enum KISVolumeCount: KISQueryRepresentable {
    case all
    case over(String)
    
    public var httpQuery: [String: String] {
        var result = ["FID_VOL_CNT": ""]
        switch self {
        case .all:
            break
        case .over(let volume):
            result["FID_VOL_CNT"] = volume
        }
        return result
    }
    
    var description: String {
        switch self {
        case .all:
            "특정 거래량"
        case .over(let volume):
            "전체 거래량"
        }
    }
}
