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
        let stationCode: String
        let direction: String
        let destination: String
        let remainTime: String
        let trainNumber: String
        let stationLineNumber: String
        let lineList: String
        
        enum CodingKeys: String, CodingKey {
            case stationCode = "statnId"
            case direction = "updnLine"
            case destination = "bstatnNm"
            case remainTime = "arvlMsg2"
            case trainNumber = "btrainNo"
            case stationLineNumber = "subwayId"
            case lineList = "subwayList"
        }
    }
}

