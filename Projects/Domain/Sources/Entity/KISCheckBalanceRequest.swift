//
//  KISCheckBalanceRequest.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public struct KISCheckBalanceRequest {
    public let investType: InvestType
    public let accountRequest: BalanceRequest
    public let authorization: String
}

public struct BalanceRequest {
    let accountNumber: String
    let accountCode: String
    let isAfterHour: Bool
    let isOffLine: Bool
    let inquiry: Inquiry
    let isContainFund: Bool
    let isContainPreviousTrading: Bool
    let continuousPrimaryKey: String
    let continuousForeignKey: String
    
    public init(
        accountNumber: String,
        accountCode: String = "01",
        isAfterHour: Bool = false,
        isOffLine: Bool = false,
        inquiry: Inquiry = .stocks,
        isContainFund: Bool = false,
        isContainPreviousTrading: Bool = true,
        continuousPrimaryKey: String = "",
        continuousForeignKey: String = ""
    ) {
        self.accountNumber = accountNumber
        self.accountCode = accountCode
        self.isAfterHour = isAfterHour
        self.isOffLine = isOffLine
        self.inquiry = inquiry
        self.isContainFund = isContainFund
        self.isContainPreviousTrading = isContainPreviousTrading
        self.continuousPrimaryKey = continuousPrimaryKey
        self.continuousForeignKey = continuousForeignKey
    }
}

extension BalanceRequest {
    public var toQuery: [String: String] {
        [
            // 종합계좌번호
            // 계좌번호 체계(8-2)의 앞 8자리
            "CANO": accountNumber,
            // 계좌상품코드
            // 계좌번호 체계(8-2)의 뒤 2자리
            "ACNT_PRDT_CD": accountCode,
            // 시간외단일가여부
            // N : 기본값 Y : 시간외단일가
            "AFHR_FLPR_YN": isAfterHour ? "Y" : "N",
            // 오프라인여부
            // 공란(Default)
            "OFL_YN": isOffLine ? "" : "",
            // 조회구분
            // 01 : 대출일별 02 : 종목별
            "INQR_DVSN": inquiry.rawValue,
            // 단가구분
            // 01 : 기본값
            "UNPR_DVSN": "01",
            // 펀드결제분포함여부
            // N : 포함하지 않음 Y : 포함
            "FUND_STTL_ICLD_YN": isContainFund ? "Y" : "N",
            // 융자금액자동상환여부
            // N : 기본값
            "FNCG_AMT_AUTO_RDPT_YN": "N",
            // 처리구분
            // 00 : 전일매매포함 01 : 전일매매미포함
            "PRCS_DVSN": isContainPreviousTrading ? "00" : "01",
            // 연속조회검색조건
            // 공란 : 최초 조회시 이전 조회 Output CTX_AREA_FK100 값 : 다음페이지 조회시(2번째부터)
            "CTX_AREA_FK100": continuousPrimaryKey,
            // 연속조회키
            // 공란 : 최초 조회시 이전 조회 Output CTX_AREA_NK100 값 : 다음페이지 조회시(2번째부터)
            "CTX_AREA_NK100": continuousForeignKey,
        ]
    }
}

public extension BalanceRequest {
    enum Inquiry: String {
        case loanDate = "01"
        case stocks = "02"
    }
}
