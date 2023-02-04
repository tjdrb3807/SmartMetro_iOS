//
//  StationDetailView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/14.
//

import UIKit
import SnapKit
import SwiftUI
import Alamofire

class StationDetailView: UIView {
    private var stationCode: Int
    private var stationInfo: [StationInfoData.Station] = []
    var realtimeArrivalList: [ArrivalData.RealTimeArrival] = []

    private var stationLineInfoDataList: [StationLineInfoData] = []
    private var realTimeArrivalInfoDataList: [ArrivalData.RealTimeArrival] = []
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 16.0, bottom: 0.0, right: 16.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let controlSectionView = ControlSectionView(lineList: stationLineInfoDataList)
        let horizontalSeparatorView = HorizontalSeparatorView()
        let stationInfoSectionView = StationInfoSectionView(stationInfo: stationInfo[0])
        let arrivalSectionView = ArrivalSectionView(realTimeArrivalInfoDataList: realTimeArrivalInfoDataList)
        let spacingView = UIView()
        
        controlSectionView.tag = 100
        horizontalSeparatorView.tag = 101
        stationInfoSectionView.tag = 102
        arrivalSectionView.tag = 103
        spacingView.tag = 104

        [controlSectionView, horizontalSeparatorView, stationInfoSectionView, arrivalSectionView, spacingView].forEach { stackView.addArrangedSubview($0) }
    
        stackView.setCustomSpacing(8.0, after: controlSectionView)
        stackView.setCustomSpacing(8.0, after: horizontalSeparatorView)
        stackView.setCustomSpacing(8.0, after: stationInfoSectionView)
        
        return stackView
    }()
    
    init(stationCode: Int) {
        self.stationCode = stationCode
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        self.fetchStationInfoData(complitionHandler: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(result):
                self.stationInfo = result.stationInfo
                self.saveStationInfoData()
                
                self.fetchStationArrivalData(complitionHandler: { result in
                    switch result {
                    case let .success(result):
                        self.realtimeArrivalList = result.realtimeArrivalList
                        self.saveRealTiemArrivalData()
                        
                        print("StationCode: \(self.stationCode)")
                        print(self.stationLineInfoDataList)
                        print(self.realTimeArrivalInfoDataList)
                        
                    case let .failure(error):
                        debugPrint(error.localizedDescription)
                    }
                    self.setUp()
                })
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        })
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("tapLineButton"),
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fetchStationInfoData(complitionHandler: @escaping (Result<StationInfoData, Error>) -> Void) {
//        let url = "http://192.168.0.8:8080/api/v2/stations/\(stationCode)"  // 디바이스 용 URL
        let url = "http://localhost:8080/api/v2/stations/\(stationCode)"  // 시뮬레이터 용 URL
        
        AF.request(url, method: .get)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(StationInfoData.self, from: data)
                        complitionHandler(.success(result))
                    } catch {
                        complitionHandler(.failure(error))
                        print(error.localizedDescription)
                    }
                case let .failure(error):
                    complitionHandler(.failure(error))
                }
            })
    }
    
    private func fetchStationArrivalData(complitionHandler: @escaping (Result<ArrivalData, Error>) -> Void) {
        let url = "http://swopenAPI.seoul.go.kr/api/subway/584c557a7a746a64313238637a596343/json/realtimeStationArrival/0/25/\(self.stationInfo[0].stationName)"
        
        AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", method: .get)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ArrivalData.self, from: data)
                        complitionHandler(.success(result))
                    } catch {
                        complitionHandler(.failure(error))
                    }
                case let .failure(error):
                    complitionHandler(.failure(error))
                }
            })
    }
    
    private func saveStationInfoData() {
        let list: [String] = self.stationInfo[0].stationLineCode.components(separatedBy: ",")
        
        var isChecked: Bool
        
        for station in list {
            isChecked = Int(station) == self.stationCode ? true : false
            let data = StationLineInfoData(stationCode: station, isChecked: isChecked)
            self.stationLineInfoDataList.append(data)
        }
    }
    
    private func saveRealTiemArrivalData() {
        for data in self.realtimeArrivalList {
            if Int(data.stationCode.suffix(4))! == self.stationCode {
                self.realTimeArrivalInfoDataList.append(data)
            }
        }
    }
    
    @objc func updateData(_ notification: Notification) {
        guard let stationCode = notification.object as? Int else { return }
        self.stationCode = stationCode
        self.stationInfo = []
        self.stationLineInfoDataList = []
        self.realtimeArrivalList = []
        self.realTimeArrivalInfoDataList = []
        
        self.fetchStationInfoData(complitionHandler: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(result):
                self.stationInfo = result.stationInfo
                self.saveStationInfoData()
                
                self.fetchStationArrivalData(complitionHandler: { result in
                    switch result {
                    case let .success(result):
                        self.realtimeArrivalList = result.realtimeArrivalList
                        self.saveRealTiemArrivalData()
                        
                        
                        print("StationCode: \(self.stationCode)")
                        print(self.stationLineInfoDataList)
                        print(self.realTimeArrivalInfoDataList)
                        
                        self.stackView.viewWithTag(100)?.removeFromSuperview()
                        self.stackView.viewWithTag(101)?.removeFromSuperview()
                        self.stackView.viewWithTag(102)?.removeFromSuperview()
                        self.stackView.viewWithTag(103)?.removeFromSuperview()
                        self.stackView.viewWithTag(104)?.removeFromSuperview()
                        
                        let controlSectionView = ControlSectionView(lineList: self.stationLineInfoDataList)
                        let horizontalSeparatorView = HorizontalSeparatorView()
                        let stationInfoSectionView = StationInfoSectionView(stationInfo: self.stationInfo[0])
                        let arrivalSectionView = ArrivalSectionView(realTimeArrivalInfoDataList: self.realTimeArrivalInfoDataList)
                        let spacingView = UIView()
                        
                        controlSectionView.tag = 100
                        horizontalSeparatorView.tag = 101
                        stationInfoSectionView.tag = 102
                        arrivalSectionView.tag = 103
                        spacingView.tag = 104

                        [controlSectionView, horizontalSeparatorView, stationInfoSectionView, arrivalSectionView, spacingView].forEach { self.stackView.addArrangedSubview($0) }
                        
                        self.stackView.setCustomSpacing(8.0, after: controlSectionView)
                        self.stackView.setCustomSpacing(8.0, after: horizontalSeparatorView)
                        self.stackView.setCustomSpacing(8.0, after: stationInfoSectionView)

                        self.setUp()
                        
                        
                    case let .failure(error):
                        debugPrint(error.localizedDescription)
                    }
                })
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        })
    }
}

extension StationDetailView {
    func setUp() {
        print("CALL: StationDetailView.setUp()")
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.arrangedSubviews[0].snp.makeConstraints {
            $0.height.equalTo(30.0)
        }
        
        stackView.arrangedSubviews[2].snp.makeConstraints {
            $0.height.equalTo(50.0)
        }
        
        stackView.arrangedSubviews[3].snp.makeConstraints {
            $0.height.equalTo(40.0)
        }
    }
}
