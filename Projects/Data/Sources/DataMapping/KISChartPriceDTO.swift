//
//  KISChartPriceDTO.swift
//  Data
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain

struct KISChartPriceDTO: Codable {
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

extension KISChartPriceDTO {
    var toDomain: [Candle] {
        output2.compactMap {
            Candle(
                date: $0.stckBsopDate,
                startPrice: $0.stckOprc,
                lowestPrice: $0.stckLwpr,
                highestPrice: $0.stckHgpr,
                closePrice: $0.stckClpr
            )
        }
    }
    
    // MARK: - Output1
    struct Output1: Codable {
        let prdyVrss, prdyVrssSign, prdyCtrt, stckPrdyClpr: String
        let acmlVol, acmlTrPbmn, htsKorIsnm, stckPrpr: String
        let stckShrnIscd, prdyVol, stckMxpr, stckLlam: String
        let stckOprc, stckHgpr, stckLwpr, stckPrdyOprc: String
        let stckPrdyHgpr, stckPrdyLwpr, askp, bidp: String
        let prdyVrssVol, volTnrt, stckFcam, lstnStcn: String
        let cpfn, htsAvls, per, eps: String
        let pbr, itewholLoanRmndRatemName: String
        
        enum CodingKeys: String, CodingKey {
            case prdyVrss = "prdy_vrss"
            case prdyVrssSign = "prdy_vrss_sign"
            case prdyCtrt = "prdy_ctrt"
            case stckPrdyClpr = "stck_prdy_clpr"
            case acmlVol = "acml_vol"
            case acmlTrPbmn = "acml_tr_pbmn"
            case htsKorIsnm = "hts_kor_isnm"
            case stckPrpr = "stck_prpr"
            case stckShrnIscd = "stck_shrn_iscd"
            case prdyVol = "prdy_vol"
            case stckMxpr = "stck_mxpr"
            case stckLlam = "stck_llam"
            case stckOprc = "stck_oprc"
            case stckHgpr = "stck_hgpr"
            case stckLwpr = "stck_lwpr"
            case stckPrdyOprc = "stck_prdy_oprc"
            case stckPrdyHgpr = "stck_prdy_hgpr"
            case stckPrdyLwpr = "stck_prdy_lwpr"
            case askp, bidp
            case prdyVrssVol = "prdy_vrss_vol"
            case volTnrt = "vol_tnrt"
            case stckFcam = "stck_fcam"
            case lstnStcn = "lstn_stcn"
            case cpfn
            case htsAvls = "hts_avls"
            case per, eps, pbr
            case itewholLoanRmndRatemName = "itewhol_loan_rmnd_ratem name"
        }
    }
    
    // MARK: - Output2
    struct Output2: Codable {
        let stckBsopDate, stckClpr, stckOprc, stckHgpr: String
        let stckLwpr, acmlVol, acmlTrPbmn, flngClsCode: String
        let prttRate, modYn, prdyVrssSign, prdyVrss: String
        let revlIssuReas: String
        
        enum CodingKeys: String, CodingKey {
            case stckBsopDate = "stck_bsop_date"
            case stckClpr = "stck_clpr"
            case stckOprc = "stck_oprc"
            case stckHgpr = "stck_hgpr"
            case stckLwpr = "stck_lwpr"
            case acmlVol = "acml_vol"
            case acmlTrPbmn = "acml_tr_pbmn"
            case flngClsCode = "flng_cls_code"
            case prttRate = "prtt_rate"
            case modYn = "mod_yn"
            case prdyVrssSign = "prdy_vrss_sign"
            case prdyVrss = "prdy_vrss"
            case revlIssuReas = "revl_issu_reas"
        }
    }
}
