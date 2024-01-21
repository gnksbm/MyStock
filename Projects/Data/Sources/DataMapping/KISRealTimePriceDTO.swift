//
//  KISRealTimePriceDTO.swift
//  Data
//
//  Created by gnksbm on 2024/01/05.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

struct KISRealTimePriceDTO: Codable {
    let mkscShrnIscd, bsopHour, hourClsCode: String
    let askp1, askp2, askp3, askp4: String
    let askp5, askp6, askp7, askp8: String
    let askp9, askp10, bidp1, bidp2: String
    let bidp3, bidp4, bidp5, bidp6: String
    let bidp7, bidp8, bidp9, bidp10: String
    let askpRsqn1, askpRsqn2, askpRsqn3, askpRsqn4: String
    let askpRsqn5, askpRsqn6, askpRsqn7, askpRsqn8: String
    let askpRsqn9, askpRsqn10, bidpRsqn1, bidpRsqn2: String
    let bidpRsqn3, bidpRsqn4, bidpRsqn5, bidpRsqn6: String
    let bidpRsqn7, bidpRsqn8, bidpRsqn9, bidpRsqn10: String
    let totalAskpRsqn, totalBidpRsqn, ovtmTotalAskpRsqn: String
    let ovtmTotalBidpRsqn: String
    let antcCnpr, antcCnqn, antcVol, antcCntgVrss: String
    let antcCntgVrssSign: String
    let antcCntgPrdyCtrt, acmlVol, totalAskpRsqnIcdc, totalBidpRsqnIcdc: String
    let ovtmTotalAskpIcdc, ovtmTotalBidpIcdc: String
    
    enum CodingKeys: String, CodingKey {
        case mkscShrnIscd = "MKSC_SHRN_ISCD"
        case bsopHour = "BSOP_HOUR"
        case hourClsCode = "HOUR_CLS_CODE"
        case askp1 = "ASKP1"
        case askp2 = "ASKP2"
        case askp3 = "ASKP3"
        case askp4 = "ASKP4"
        case askp5 = "ASKP5"
        case askp6 = "ASKP6"
        case askp7 = "ASKP7"
        case askp8 = "ASKP8"
        case askp9 = "ASKP9"
        case askp10 = "ASKP10"
        case bidp1 = "BIDP1"
        case bidp2 = "BIDP2"
        case bidp3 = "BIDP3"
        case bidp4 = "BIDP4"
        case bidp5 = "BIDP5"
        case bidp6 = "BIDP6"
        case bidp7 = "BIDP7"
        case bidp8 = "BIDP8"
        case bidp9 = "BIDP9"
        case bidp10 = "BIDP10"
        case askpRsqn1 = "ASKP_RSQN1"
        case askpRsqn2 = "ASKP_RSQN2"
        case askpRsqn3 = "ASKP_RSQN3"
        case askpRsqn4 = "ASKP_RSQN4"
        case askpRsqn5 = "ASKP_RSQN5"
        case askpRsqn6 = "ASKP_RSQN6"
        case askpRsqn7 = "ASKP_RSQN7"
        case askpRsqn8 = "ASKP_RSQN8"
        case askpRsqn9 = "ASKP_RSQN9"
        case askpRsqn10 = "ASKP_RSQN10"
        case bidpRsqn1 = "BIDP_RSQN1"
        case bidpRsqn2 = "BIDP_RSQN2"
        case bidpRsqn3 = "BIDP_RSQN3"
        case bidpRsqn4 = "BIDP_RSQN4"
        case bidpRsqn5 = "BIDP_RSQN5"
        case bidpRsqn6 = "BIDP_RSQN6"
        case bidpRsqn7 = "BIDP_RSQN7"
        case bidpRsqn8 = "BIDP_RSQN8"
        case bidpRsqn9 = "BIDP_RSQN9"
        case bidpRsqn10 = "BIDP_RSQN10"
        case totalAskpRsqn = "TOTAL_ASKP_RSQN"
        case totalBidpRsqn = "TOTAL_BIDP_RSQN"
        case ovtmTotalAskpRsqn = "OVTM_TOTAL_ASKP_RSQN"
        case ovtmTotalBidpRsqn = "OVTM_TOTAL_BIDP_RSQN"
        case antcCnpr = "ANTC_CNPR"
        case antcCnqn = "ANTC_CNQN"
        case antcVol = "ANTC_VOL"
        case antcCntgVrss = "ANTC_CNTG_VRSS"
        case antcCntgVrssSign = "ANTC_CNTG_VRSS_SIGN"
        case antcCntgPrdyCtrt = "ANTC_CNTG_PRDY_CTRT"
        case acmlVol = "ACML_VOL"
        case totalAskpRsqnIcdc = "TOTAL_ASKP_RSQN_ICDC"
        case totalBidpRsqnIcdc = "TOTAL_BIDP_RSQN_ICDC"
        case ovtmTotalAskpIcdc = "OVTM_TOTAL_ASKP_ICDC"
        case ovtmTotalBidpIcdc = "OVTM_TOTAL_BIDP_ICDC"
    }
    
    init?(str: String) {
        var resultDic = [String: String]()
        let mirror = Mirror(reflecting: KISRealTimePriceDTO.CodingKeys.self)
        guard let valueArr = str
            .split(separator: "|")
            .last?
            .split(separator: "^")
        else { return nil }
        let labelArr = mirror.children.compactMap {
            $0.label?.codingKey as? String
        }
        for index in 0..<labelArr.count {
            resultDic[labelArr[index]] = String(valueArr[index])
        }
        guard let data = try? JSONSerialization.data(withJSONObject: resultDic),
              let any = try? JSONSerialization.jsonObject(with: data)
        else { return nil }
        if JSONSerialization.isValidJSONObject(any) {
            guard let result = try? data.decode(type: KISRealTimePriceDTO.self)
            else { return nil }
            self = result
        }
        return nil
    }
}
//
//{
//    "MKSC_SHRN_ISCD" : "",
//    "BSOP_HOUR" : "",
//    "HOUR_CLS_CODE" : "",
//    "ASKP1" : 0,
//    "ASKP2" : 0,
//    "ASKP3" : 0,
//    "ASKP4" : 0,
//    "ASKP5" : 0,
//    "ASKP6" : 0,
//    "ASKP7" : 0,
//    "ASKP8" : 0,
//    "ASKP9" : 0,
//    "ASKP10" : 0,
//    "BIDP1" : 0,
//    "BIDP2" : 0,
//    "BIDP3" : 0,
//    "BIDP4" : 0,
//    "BIDP5" : 0,
//    "BIDP6" : 0,
//    "BIDP7" : 0,
//    "BIDP8" : 0,
//    "BIDP9" : 0,
//    "BIDP10" : 0,
//    "ASKP_RSQN1" : 0,
//    "ASKP_RSQN2" : 0,
//    "ASKP_RSQN3" : 0,
//    "ASKP_RSQN4" : 0,
//    "ASKP_RSQN5" : 0,
//    "ASKP_RSQN6" : 0,
//    "ASKP_RSQN7" : 0,
//    "ASKP_RSQN8" : 0,
//    "ASKP_RSQN9" : 0,
//    "ASKP_RSQN10" : 0,
//    "BIDP_RSQN1" : 0,
//    "BIDP_RSQN2" : 0,
//    "BIDP_RSQN3" : 0,
//    "BIDP_RSQN4" : 0,
//    "BIDP_RSQN5" : 0,
//    "BIDP_RSQN6" : 0,
//    "BIDP_RSQN7" : 0,
//    "BIDP_RSQN8" : 0,
//    "BIDP_RSQN9" : 0,
//    "BIDP_RSQN10" : 0,
//    "TOTAL_ASKP_RSQN" : 0,
//    "TOTAL_BIDP_RSQN" : 0,
//    "OVTM_TOTAL_ASKP_RSQN" : 0,
//    "OVTM_TOTAL_BIDP_RSQN" : 0,
//    "ANTC_CNPR" : 0,
//    "ANTC_CNQN" : 0,
//    "ANTC_VOL" : 0,
//    "ANTC_CNTG_VRSS" : 0,
//    "ANTC_CNTG_VRSS_SIGN" : "",
//    "ANTC_CNTG_PRDY_CTRT" : 0,
//    "ACML_VOL" : 0,
//    "TOTAL_ASKP_RSQN_ICDC" : 0,
//    "TOTAL_BIDP_RSQN_ICDC" : 0,
//    "OVTM_TOTAL_ASKP_ICDC" : 0,
//    "OVTM_TOTAL_BIDP_ICDC" : 0
//}
