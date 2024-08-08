//
//  KISTopMarketCapDTO.swift
//  Data
//
//  Created by gnksbm on 8/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

struct KISTopMarketCapDTO: Codable {
    let output: [Output]
    let rtCD, msgCD, msg1: String

    enum CodingKeys: String, CodingKey {
        case output
        case rtCD = "rt_cd"
        case msgCD = "msg_cd"
        case msg1
    }
}

extension KISTopMarketCapDTO {
    func toResponse() -> [KISTopRankResponse] {
        output.map {
            KISTopRankResponse(
                rank: $0.dataRank,
                name: $0.htsKorIsnm,
                ticker: $0.mkscShrnIscd,
                price: $0.stckPrpr,
                fluctuationRate: $0.prdyCtrt
            )
        }
    }
}

extension KISTopMarketCapDTO {
    struct Output: Codable {
        let mkscShrnIscd, dataRank, htsKorIsnm, stckPrpr: String
        let prdyVrss, prdyVrssSign, prdyCtrt, acmlVol: String
        let lstnStcn, stckAvls, mrktWholAvlsRlim: String
        
        enum CodingKeys: String, CodingKey {
            case mkscShrnIscd = "mksc_shrn_iscd"
            case dataRank = "data_rank"
            case htsKorIsnm = "hts_kor_isnm"
            case stckPrpr = "stck_prpr"
            case prdyVrss = "prdy_vrss"
            case prdyVrssSign = "prdy_vrss_sign"
            case prdyCtrt = "prdy_ctrt"
            case acmlVol = "acml_vol"
            case lstnStcn = "lstn_stcn"
            case stckAvls = "stck_avls"
            case mrktWholAvlsRlim = "mrkt_whol_avls_rlim"
        }
    }
}
