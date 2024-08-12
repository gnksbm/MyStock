//
//  KISDailyChartPriceDTO.swift
//  Data
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

public struct KISDailyChartPriceDTO: Codable {
    let output1: Output1
    let output2: [Output2]
    let rtCD, msgCD, msg1: String

    enum CodingKeys: String, CodingKey {
        case output1, output2
        case rtCD = "rt_cd"
        case msgCD = "msg_cd"
        case msg1
    }
}

extension KISDailyChartPriceDTO {
    func toResponse(ticker: String) -> KISDailyChartPriceResponse {
        KISDailyChartPriceResponse(
            name: output1.htsKorIsnm,
            price: output1.stckPrpr,
            fluctuationRate: output1.prdyCtrt,
            ticker: ticker,
            volume: output1.acmlVol,
            candles: output2.compactMap {
                CandleData(
                    date: $0.stckBsopDate + $0.stckCntgHour,
                    openingPrice: $0.stckOprc,
                    highestPrice: $0.stckHgpr,
                    lowestPrice: $0.stckLwpr,
                    closingPrice: $0.stckPrpr,
                    dateFormat: .dailyChartResponse
                )
            }
        )
    }
}

extension KISDailyChartPriceDTO {
    struct Output1: Codable {
        let acmlTrPbmn, acmlVol, htsKorIsnm, prdyCtrt: String
        let prdyVrss, prdyVrssSign, stckPrdyClpr, stckPrpr: String
        
        enum CodingKeys: String, CodingKey {
            case acmlTrPbmn = "acml_tr_pbmn"
            case acmlVol = "acml_vol"
            case htsKorIsnm = "hts_kor_isnm"
            case prdyCtrt = "prdy_ctrt"
            case prdyVrss = "prdy_vrss"
            case prdyVrssSign = "prdy_vrss_sign"
            case stckPrdyClpr = "stck_prdy_clpr"
            case stckPrpr = "stck_prpr"
        }
    }
    
    struct Output2: Codable {
        let acmlTrPbmn, cntgVol, stckBsopDate, stckCntgHour: String
        let stckHgpr, stckLwpr, stckOprc, stckPrpr: String
        
        enum CodingKeys: String, CodingKey {
            case acmlTrPbmn = "acml_tr_pbmn"
            case cntgVol = "cntg_vol"
            case stckBsopDate = "stck_bsop_date"
            case stckCntgHour = "stck_cntg_hour"
            case stckHgpr = "stck_hgpr"
            case stckLwpr = "stck_lwpr"
            case stckOprc = "stck_oprc"
            case stckPrpr = "stck_prpr"
        }
    }
}
