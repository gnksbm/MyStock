//
//  KISCheckBalanceDTO.swift
//  Data
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

struct KISCheckBalanceDTO: Codable {
    let ctxAreaFk100, ctxAreaNk100: String
    let output1: [Output1]
    let output2: [Output2]
    let rtCD, msgCD, msg1: String
    
    enum CodingKeys: String, CodingKey {
        case ctxAreaFk100 = "ctx_area_fk100"
        case ctxAreaNk100 = "ctx_area_nk100"
        case output1, output2
        case rtCD = "rt_cd"
        case msgCD = "msg_cd"
        case msg1
    }
}

extension KISCheckBalanceDTO {
    public func toDomain(marketType: MarketType) -> [KISCheckBalanceResponse] {
        output1.map {
            var division: KISCheckBalanceResponse.Division
            switch $0.tradDvsnName {
            case "현금":
                division = .cash
            case "자기융자":
                division = .loan
            default:
                division = .loan
            }
            return .init(
                ticker: $0.pdno,
                name: $0.prdtName,
                price: $0.prpr,
                amount: $0.hldgQty,
                plAmount: $0.evluPflsAmt,
                fluctuationRate: $0.flttRt,
                division: division,
                marketType: marketType
            )
        }
    }
    
    public var collateralRatio: Double {
        let totalAmount = output2
            .compactMap({ Int($0.totEvluAmt) })
            .reduce(0, { $0 + $1 })
            .f
        let loanAmount = output1
            .compactMap({ Int($0.loanAmt) })
            .reduce(0, { $0 + $1 })
            .f
        return totalAmount / loanAmount * 100.f
    }
    
    // MARK: - Output1
    struct Output1: Codable {
        let pdno, prdtName, tradDvsnName, bfdyBuyQty: String
        let bfdySllQty, thdtBuyqty, thdtSllQty, hldgQty: String
        let ordPsblQty, pchsAvgPric, pchsAmt, prpr: String
        let evluAmt, evluPflsAmt, evluPflsRt, evluErngRt: String
        let loanDt, loanAmt, stlnSlngChgs, expdDt: String
        let flttRt, bfdyCprsIcdc, itemMgnaRtName, grtaRtName: String
        let sbstPric, stckLoanUnpr: String
        
        enum CodingKeys: String, CodingKey {
            case pdno
            case prdtName = "prdt_name"
            case tradDvsnName = "trad_dvsn_name"
            case bfdyBuyQty = "bfdy_buy_qty"
            case bfdySllQty = "bfdy_sll_qty"
            case thdtBuyqty = "thdt_buyqty"
            case thdtSllQty = "thdt_sll_qty"
            case hldgQty = "hldg_qty"
            case ordPsblQty = "ord_psbl_qty"
            case pchsAvgPric = "pchs_avg_pric"
            case pchsAmt = "pchs_amt"
            case prpr
            case evluAmt = "evlu_amt"
            case evluPflsAmt = "evlu_pfls_amt"
            case evluPflsRt = "evlu_pfls_rt"
            case evluErngRt = "evlu_erng_rt"
            case loanDt = "loan_dt"
            case loanAmt = "loan_amt"
            case stlnSlngChgs = "stln_slng_chgs"
            case expdDt = "expd_dt"
            case flttRt = "fltt_rt"
            case bfdyCprsIcdc = "bfdy_cprs_icdc"
            case itemMgnaRtName = "item_mgna_rt_name"
            case grtaRtName = "grta_rt_name"
            case sbstPric = "sbst_pric"
            case stckLoanUnpr = "stck_loan_unpr"
        }
    }
    
    // MARK: - Output2
    struct Output2: Codable {
        let dncaTotAmt, nxdyExccAmt, prvsRcdlExccAmt, cmaEvluAmt: String
        let bfdyBuyAmt, thdtBuyAmt, nxdyAutoRdptAmt, bfdySllAmt: String
        let thdtSllAmt, d2AutoRdptAmt, bfdyTlexAmt, thdtTlexAmt: String
        let totLoanAmt, sctsEvluAmt, totEvluAmt, nassAmt: String
        let fncgGldAutoRdptYn, pchsAmtSmtlAmt: String
        let evluAmtSmtlAmt, evluPflsSmtlAmt: String
        let totStlnSlngChgs, bfdyTotAsstEvluAmt, asstIcdcAmt: String
        let asstIcdcErngRt: String
        
        enum CodingKeys: String, CodingKey {
            case dncaTotAmt = "dnca_tot_amt"
            case nxdyExccAmt = "nxdy_excc_amt"
            case prvsRcdlExccAmt = "prvs_rcdl_excc_amt"
            case cmaEvluAmt = "cma_evlu_amt"
            case bfdyBuyAmt = "bfdy_buy_amt"
            case thdtBuyAmt = "thdt_buy_amt"
            case nxdyAutoRdptAmt = "nxdy_auto_rdpt_amt"
            case bfdySllAmt = "bfdy_sll_amt"
            case thdtSllAmt = "thdt_sll_amt"
            case d2AutoRdptAmt = "d2_auto_rdpt_amt"
            case bfdyTlexAmt = "bfdy_tlex_amt"
            case thdtTlexAmt = "thdt_tlex_amt"
            case totLoanAmt = "tot_loan_amt"
            case sctsEvluAmt = "scts_evlu_amt"
            case totEvluAmt = "tot_evlu_amt"
            case nassAmt = "nass_amt"
            case fncgGldAutoRdptYn = "fncg_gld_auto_rdpt_yn"
            case pchsAmtSmtlAmt = "pchs_amt_smtl_amt"
            case evluAmtSmtlAmt = "evlu_amt_smtl_amt"
            case evluPflsSmtlAmt = "evlu_pfls_smtl_amt"
            case totStlnSlngChgs = "tot_stln_slng_chgs"
            case bfdyTotAsstEvluAmt = "bfdy_tot_asst_evlu_amt"
            case asstIcdcAmt = "asst_icdc_amt"
            case asstIcdcErngRt = "asst_icdc_erng_rt"
        }
    }
}
