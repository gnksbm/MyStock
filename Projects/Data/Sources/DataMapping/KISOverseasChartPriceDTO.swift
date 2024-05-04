//
//  KISOverseasChartPriceDTO.swift
//  Data
//
//  Created by gnksbm on 1/21/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

struct KISOverseasChartPriceDTO: Codable {
    let output1: Output1
    let output2: [Output2]
}

extension KISOverseasChartPriceDTO {
    var toDomain: [KISChartPriceResponse] {
        output2.compactMap {
            .init(
                date: $0.stckBsopDate,
                openingPrice: $0.ovrsNmixOprc,
                highestPrice: $0.ovrsNmixHgpr,
                lowestPrice: $0.ovrsNmixLwpr,
                closingPrice: $0.ovrsNmixPrpr
            )
        }
    }
    // MARK: - Output1
    struct Output1: Codable {
        let acmlVol, htsKorIsnm, ovrsNmixPrdyClpr, ovrsNmixPrdyVrss: String
        let ovrsNmixPrpr, ovrsProdHgpr, ovrsProdLwpr, ovrsProdOprc: String
        let prdyCtrt, prdyVrssSign, stckShrnIscd: String
        
        enum CodingKeys: String, CodingKey {
            case acmlVol = "acml_vol"
            case htsKorIsnm = "hts_kor_isnm"
            case ovrsNmixPrdyClpr = "ovrs_nmix_prdy_clpr"
            case ovrsNmixPrdyVrss = "ovrs_nmix_prdy_vrss"
            case ovrsNmixPrpr = "ovrs_nmix_prpr"
            case ovrsProdHgpr = "ovrs_prod_hgpr"
            case ovrsProdLwpr = "ovrs_prod_lwpr"
            case ovrsProdOprc = "ovrs_prod_oprc"
            case prdyCtrt = "prdy_ctrt"
            case prdyVrssSign = "prdy_vrss_sign"
            case stckShrnIscd = "stck_shrn_iscd"
        }
    }
    
    // MARK: - Output2
    struct Output2: Codable {
        let acmlVol, modYn, ovrsNmixHgpr, ovrsNmixLwpr: String
        let ovrsNmixOprc, ovrsNmixPrpr, stckBsopDate: String
        
        enum CodingKeys: String, CodingKey {
            case acmlVol = "acml_vol"
            case modYn = "mod_yn"
            case ovrsNmixHgpr = "ovrs_nmix_hgpr"
            case ovrsNmixLwpr = "ovrs_nmix_lwpr"
            case ovrsNmixOprc = "ovrs_nmix_oprc"
            case ovrsNmixPrpr = "ovrs_nmix_prpr"
            case stckBsopDate = "stck_bsop_date"
        }
    }
}
