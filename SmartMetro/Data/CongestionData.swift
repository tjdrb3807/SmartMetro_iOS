//
//  CongestionData.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/02/05.
//

import Foundation

struct CongestionData: Decodable {
    private let data: Data
    
    struct Data: Decodable {
        let congestionResult: CongestionResult
    }
    
    struct CongestionResult: Decodable {
        let congestionAverage: String
        let congestionOfBlock: String
        
        enum CodingKeys: String, CodingKey {
            case congestionAverage = "congestionTrain"
            case congestionOfBlock = "congestionCar"
        }
    }
}


