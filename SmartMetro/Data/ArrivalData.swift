//
//  ArrivalData.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/19.
//

import Foundation

struct ArrivalData: Decodable {
    var realtimeArrivalList: [RealTimeArrival] = []
    
    struct RealTimeArrival: Decodable {
        let line: String
        let remainTime: String
        let currentStation: String
        let stationLineNumber: String
        let lineList: String
        
        enum CodingKeys: String, CodingKey {
            case line = "trainLineNm"
            case remainTime = "arvlMsg2"
            case currentStation = "arvlMsg3"
            case stationLineNumber = "subwayId"
            case lineList = "subwayList"
        }
    }
}

