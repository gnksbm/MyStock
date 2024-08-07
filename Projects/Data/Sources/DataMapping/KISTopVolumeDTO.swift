//
//  KISTopVolumeDTO.swift
//  Data
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

struct KISTopVolumeDTO: Codable {
    let output: [Output]
    let rtCD, msgCD, msg1: String

    enum CodingKeys: String, CodingKey {
        case output
        case rtCD = "rt_cd"
        case msgCD = "msg_cd"
        case msg1
    }
}

extension KISTopVolumeDTO {
    func toResponse() -> [KISTopVolumeResponse] {
        output.map {
            KISTopVolumeResponse(
                rank: $0.dataRank,
                name: $0.htsKorIsnm,
                ticker: $0.mkscShrnIscd,
                price: $0.stckPrpr,
                fluctuationRate: $0.prdyCtrt
            )
        }
    }
}

extension KISTopVolumeDTO {
    struct Output: Codable {
        let htsKorIsnm, mkscShrnIscd, dataRank, stckPrpr: String
        let prdyVrssSign, prdyVrss, prdyCtrt, acmlVol: String
        let prdyVol, lstnStcn, avrgVol, nBefrClprVrssPrprRate: String
        let volInrt, volTnrt, ndayVolTnrt, avrgTrPbmn: String
        let trPbmnTnrt, ndayTrPbmnTnrt, acmlTrPbmn: String
        
        enum CodingKeys: String, CodingKey {
            case htsKorIsnm = "hts_kor_isnm"
            case mkscShrnIscd = "mksc_shrn_iscd"
            case dataRank = "data_rank"
            case stckPrpr = "stck_prpr"
            case prdyVrssSign = "prdy_vrss_sign"
            case prdyVrss = "prdy_vrss"
            case prdyCtrt = "prdy_ctrt"
            case acmlVol = "acml_vol"
            case prdyVol = "prdy_vol"
            case lstnStcn = "lstn_stcn"
            case avrgVol = "avrg_vol"
            case nBefrClprVrssPrprRate = "n_befr_clpr_vrss_prpr_rate"
            case volInrt = "vol_inrt"
            case volTnrt = "vol_tnrt"
            case ndayVolTnrt = "nday_vol_tnrt"
            case avrgTrPbmn = "avrg_tr_pbmn"
            case trPbmnTnrt = "tr_pbmn_tnrt"
            case ndayTrPbmnTnrt = "nday_tr_pbmn_tnrt"
            case acmlTrPbmn = "acml_tr_pbmn"
        }
    }
}
