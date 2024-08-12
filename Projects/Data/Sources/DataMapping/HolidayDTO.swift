//
//  HolidayDTO.swift
//  Data
//
//  Created by gnksbm on 5/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import Domain

struct HolidayDTO: Codable {
    let header: Header
    let body: Body
}
 
extension HolidayDTO {
    var toDomain: [HolidayResponse] {
        body.items.item.compactMap { item in
            guard let date = item.locdate.formatted(dateFormat: .onlyYMD)
            else { return nil }
            return HolidayResponse(
                date: date,
                isHoliday: item.isHoliday == "Y",
                dateName: item.dateName
            )
        }
    }
}

extension HolidayDTO.Body {
    struct Items: Codable {
        let item: [Item]
    }
    struct Item: Codable {
        /// 공공기관 휴일여부
        let isHoliday: String
        /// 명칭
        let dateName: String
        /// 종류
        let dateKind: String
        /// 날짜
        let locdate: String
        /// 순번
        let seq: String
    }
}

extension HolidayDTO {
    struct Header: Codable {
        let resultCode: String
        let resultMsg: String
    }
    
    struct Body: Codable {
        let items: Items
        let numOfRows: Int
        let pageNo: Int
        let totalCount: Int
    }
}

/*<response>
 <header>
     <resultCode>00</resultCode>
     <resultMsg>NORMAL SERVICE.</resultMsg>
 </header>
 <body>
     <items>
         <item>
             <dateKind>01</dateKind>
             <dateName>어린이날</dateName>
             <isHoliday>Y</isHoliday>
             <locdate>20240505</locdate>
             <seq>1</seq>
         </item>
         <item>
             <dateKind>01</dateKind>
             <dateName>대체공휴일(어린이날)</dateName>
             <isHoliday>Y</isHoliday>
             <locdate>20240506</locdate>
             <seq>1</seq>
         </item>
         <item>
             <dateKind>01</dateKind>
             <dateName>부처님오신날</dateName>
             <isHoliday>Y</isHoliday>
             <locdate>20240515</locdate>
             <seq>1</seq>
         </item>
     </items>
     <numOfRows>10</numOfRows>
     <pageNo>1</pageNo>
     <totalCount>3</totalCount>
 </body>
</response>*/
