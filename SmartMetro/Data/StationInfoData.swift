//
//  StationInfoData.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/17.
//

import Foundation

struct StationInfoData: Decodable {
    var stationInfo: [Station] = []
    
    struct Station: Decodable {
        
        let stationName: String
        let stationLineNumber: String
        let beforeStationName: String
        let afterStationName: String
    }
    
    enum CodingKeys: String, CodingKey {
        case stationInfo = "data"
    }
}
