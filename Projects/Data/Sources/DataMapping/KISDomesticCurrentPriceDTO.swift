//
//  KISDomesticCurrentPriceDTO.swift
//  Data
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

struct KISDomesticCurrentPriceDTO: Decodable {
    let output: StockInfo
    let rtCd: String
    let msgCd: String
    let msg1: String
    
    enum CodingKeys: String, CodingKey {
        case output
        case rtCd = "rt_cd"
        case msgCd = "msg_cd"
        case msg1
    }
}

extension KISDomesticCurrentPriceDTO {
    func toResponse() -> KISCurrentPriceResponse {
        KISCurrentPriceResponse(
            name: output.rprsMrktKorName,
            ticker: output.stckShrnIscd,
            price: output.stckPrpr,
            fluctuationRate: output.prdyCtrt
        )
    }
}

extension KISDomesticCurrentPriceDTO {
    struct StockInfo: Decodable {
        let iscdStatClsCode: String
        let margRate: String
        let rprsMrktKorName: String
        let bstpKorIsnm: String
        let tempStopYn: String
        let oprcRangContYn: String
        let clprRangContYn: String
        let crdtAbleYn: String
        let grmnRateClsCode: String
        let elwPblcYn: String
        let stckPrpr: String
        let prdyVrss: String
        let prdyVrssSign: String
        let prdyCtrt: String
        let acmlTrPbmn: String
        let acmlVol: String
        let prdyVrssVolRate: String
        let stckOprc: String
        let stckHgpr: String
        let stckLwpr: String
        let stckMxpr: String
        let stckLlam: String
        let stckSdpr: String
        let wghnAvrgStckPrc: String
        let htsFrgnEhrt: String
        let frgnNtbyQty: String
        let pgtrNtbyQty: String
        let pvtScndDmrsPrc: String
        let pvtFrstDmrsPrc: String
        let pvtPontVal: String
        let pvtFrstDmspPrc: String
        let pvtScndDmspPrc: String
        let dmrsVal: String
        let dmspVal: String
        let cpfn: String
        let rstcWdthPrc: String
        let stckFcam: String
        let stckSspr: String
        let asprUnit: String
        let htsDealQtyUnitVal: String
        let lstnStcn: String
        let htsAvls: String
        let per: String
        let pbr: String
        let stacMonth: String
        let volTnrt: String
        let eps: String
        let bps: String
        let d250Hgpr: String
        let d250HgprDate: String
        let d250HgprVrssPrprRate: String
        let d250Lwpr: String
        let d250LwprDate: String
        let d250LwprVrssPrprRate: String
        let stckDryyHgpr: String
        let dryyHgprVrssPrprRate: String
        let dryyHgprDate: String
        let stckDryyLwpr: String
        let dryyLwprVrssPrprRate: String
        let dryyLwprDate: String
        let w52Hgpr: String
        let w52HgprVrssPrprCtrt: String
        let w52HgprDate: String
        let w52Lwpr: String
        let w52LwprVrssPrprCtrt: String
        let w52LwprDate: String
        let wholLoanRmndRate: String
        let sstsYn: String
        let stckShrnIscd: String
        let fcamCnnm: String
        let cpfnCnnm: String
        let frgnHldnQty: String
        let viClsCode: String
        let ovtmViClsCode: String
        let lastSstsCntgQty: String
        let invtCafulYn: String
        let mrktWarnClsCode: String
        let shortOverYn: String
        let sltrYn: String
        
        enum CodingKeys: String, CodingKey {
            case iscdStatClsCode = "iscd_stat_cls_code"
            case margRate = "marg_rate"
            case rprsMrktKorName = "rprs_mrkt_kor_name"
            case bstpKorIsnm = "bstp_kor_isnm"
            case tempStopYn = "temp_stop_yn"
            case oprcRangContYn = "oprc_rang_cont_yn"
            case clprRangContYn = "clpr_rang_cont_yn"
            case crdtAbleYn = "crdt_able_yn"
            case grmnRateClsCode = "grmn_rate_cls_code"
            case elwPblcYn = "elw_pblc_yn"
            case stckPrpr = "stck_prpr"
            case prdyVrss = "prdy_vrss"
            case prdyVrssSign = "prdy_vrss_sign"
            case prdyCtrt = "prdy_ctrt"
            case acmlTrPbmn = "acml_tr_pbmn"
            case acmlVol = "acml_vol"
            case prdyVrssVolRate = "prdy_vrss_vol_rate"
            case stckOprc = "stck_oprc"
            case stckHgpr = "stck_hgpr"
            case stckLwpr = "stck_lwpr"
            case stckMxpr = "stck_mxpr"
            case stckLlam = "stck_llam"
            case stckSdpr = "stck_sdpr"
            case wghnAvrgStckPrc = "wghn_avrg_stck_prc"
            case htsFrgnEhrt = "hts_frgn_ehrt"
            case frgnNtbyQty = "frgn_ntby_qty"
            case pgtrNtbyQty = "pgtr_ntby_qty"
            case pvtScndDmrsPrc = "pvt_scnd_dmrs_prc"
            case pvtFrstDmrsPrc = "pvt_frst_dmrs_prc"
            case pvtPontVal = "pvt_pont_val"
            case pvtFrstDmspPrc = "pvt_frst_dmsp_prc"
            case pvtScndDmspPrc = "pvt_scnd_dmsp_prc"
            case dmrsVal = "dmrs_val"
            case dmspVal = "dmsp_val"
            case cpfn = "cpfn"
            case rstcWdthPrc = "rstc_wdth_prc"
            case stckFcam = "stck_fcam"
            case stckSspr = "stck_sspr"
            case asprUnit = "aspr_unit"
            case htsDealQtyUnitVal = "hts_deal_qty_unit_val"
            case lstnStcn = "lstn_stcn"
            case htsAvls = "hts_avls"
            case per = "per"
            case pbr = "pbr"
            case stacMonth = "stac_month"
            case volTnrt = "vol_tnrt"
            case eps = "eps"
            case bps = "bps"
            case d250Hgpr = "d250_hgpr"
            case d250HgprDate = "d250_hgpr_date"
            case d250HgprVrssPrprRate = "d250_hgpr_vrss_prpr_rate"
            case d250Lwpr = "d250_lwpr"
            case d250LwprDate = "d250_lwpr_date"
            case d250LwprVrssPrprRate = "d250_lwpr_vrss_prpr_rate"
            case stckDryyHgpr = "stck_dryy_hgpr"
            case dryyHgprVrssPrprRate = "dryy_hgpr_vrss_prpr_rate"
            case dryyHgprDate = "dryy_hgpr_date"
            case stckDryyLwpr = "stck_dryy_lwpr"
            case dryyLwprVrssPrprRate = "dryy_lwpr_vrss_prpr_rate"
            case dryyLwprDate = "dryy_lwpr_date"
            case w52Hgpr = "w52_hgpr"
            case w52HgprVrssPrprCtrt = "w52_hgpr_vrss_prpr_ctrt"
            case w52HgprDate = "w52_hgpr_date"
            case w52Lwpr = "w52_lwpr"
            case w52LwprVrssPrprCtrt = "w52_lwpr_vrss_prpr_ctrt"
            case w52LwprDate = "w52_lwpr_date"
            case wholLoanRmndRate = "whol_loan_rmnd_rate"
            case sstsYn = "ssts_yn"
            case stckShrnIscd = "stck_shrn_iscd"
            case fcamCnnm = "fcam_cnnm"
            case cpfnCnnm = "cpfn_cnnm"
            case frgnHldnQty = "frgn_hldn_qty"
            case viClsCode = "vi_cls_code"
            case ovtmViClsCode = "ovtm_vi_cls_code"
            case lastSstsCntgQty = "last_ssts_cntg_qty"
            case invtCafulYn = "invt_caful_yn"
            case mrktWarnClsCode = "mrkt_warn_cls_code"
            case shortOverYn = "short_over_yn"
            case sltrYn = "sltr_yn"
        }
    }
}
