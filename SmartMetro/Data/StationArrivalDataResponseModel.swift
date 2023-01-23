//
//  StationArrivalDataResponseModel.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/19.
//

import Foundation

struct StationArrivalDataResponseModel: Decodable {
    var realtimeArrivalList: [RealTimeArrival] = []
    
    struct RealTimeArrival: Decodable {
        let line: String
        let remainTime: String
        let currentStation: String
        let stationLineNumber: String
        
        enum CodingKeys: String, CodingKey {
            case line = "trainLineNm"
            case remainTime = "arvlMsg2"
            case currentStation = "arvlMsg3"
            case stationLineNumber = "subwayId"
        }
    }
}

