//
//  MainViewController.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/14.
//

import UIKit
import SnapKit
import SwiftUI
import Alamofire

final class MainViewController: UIViewController {
    private var stationCode: Int = 0
    private var realtimeArrivalList: [ArrivalData.RealTimeArrival] = []

    private var controlSectionViewData: [StationLineInfoData] = []
    private var stationInfoSectionViewData: [StationInfoData.Station] = []
    private var arrivalSectionViewData: [ArrivalData.RealTimeArrival] = []
    
    private lazy var mapView = MapView()
    
    private var stationDetailView: StationDetailView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadStationDetailViewAndData(_:)),
                                               name: NSNotification.Name("tapStationOrLineButton"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissStationDetailView),
                                               name: NSNotification.Name("tapDismissButtonOrImageView"),
                                               object: nil)
    }
    
    private func fetchStationInfoSectionViewData(complitionHandler: @escaping (Result<StationInfoData, Error>) -> Void) {
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
    
    private func fetchRealtimeArrivalListData(complitionHandler: @escaping (Result<ArrivalData, Error>) -> Void) {
        let url = "http://swopenAPI.seoul.go.kr/api/subway/584c557a7a746a64313238637a596343/json/realtimeStationArrival/0/25/\(self.stationInfoSectionViewData[0].stationName)"
        
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
    
    private func fetchCongestionData(complitionHandler: @escaping (Result<CongestionData, Error>) -> Void) {
        let url = "https://apis.openapi.sk.com/puzzle/congestion-train/rltm/trains/2/2312"
        
        AF.request(url, method: .get, headers: ["appkey": "l7xx1b38d2cbed974e80ab4f77d768fb5693"])
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CongestionData.self, from: data)
                        complitionHandler(.success(result))
                    } catch {
                        complitionHandler(.failure(error))
                    }
                case let .failure(error):
                    complitionHandler(.failure(error))
                }
            })
    }
    
    
    private func refineControlSectionViewData() {
        let list: [String] = self.stationInfoSectionViewData[0].stationLineCode.components(separatedBy: ",")
        var isChecked: Bool
        
        if !self.controlSectionViewData.isEmpty { self.controlSectionViewData.removeAll() }
        
        for station in list {
            isChecked = Int(station) == self.stationCode ? true : false
            let data = StationLineInfoData(stationCode: station, isChecked: isChecked)
            self.controlSectionViewData.append(data)
        }
    }
    
    private func refineArrivalSectionViewData() {
        if !self.arrivalSectionViewData.isEmpty { self.arrivalSectionViewData.removeAll() }
        
        for data in self.realtimeArrivalList {
            if Int(data.stationCode.suffix(4))! == self.stationCode {
                self.arrivalSectionViewData.append(data)
            }
        }
    }
    
    private func presentStationDetailView(stationCode: Int) {
        self.stationDetailView = StationDetailView(controlSectionViewData: controlSectionViewData, stationInfoSectionViewData: stationInfoSectionViewData, arrivalSectionViewData: arrivalSectionViewData)
        view.addSubview(stationDetailView!)
        stationDetailView?.tag = 100
        
        stationDetailView!.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc private func loadStationDetailViewAndData(_ notification: Notification) {
        guard let stationCode = notification.object as? Int else { return }
        self.stationCode = stationCode
        
        self.fetchStationInfoSectionViewData(complitionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                self.stationInfoSectionViewData = result.stationInfo
                self.refineControlSectionViewData()
                
                self.fetchRealtimeArrivalListData(complitionHandler: { result in
                    switch result {
                    case let .success(result):
                        self.realtimeArrivalList = result.realtimeArrivalList
                        self.refineArrivalSectionViewData()
                        /*
                        if stationCode == 2, 3 {
                            실시간 혼잡도 API가져오는 함수 호출
                            실시간 혼잡도까지 묶어서 argumanet로 statonDetailView 호출
                         } else {
                            기존 방법대로 presentStationDetailView 함수 호출
                         
                         */
                        let lineNumber = self.stationCode / 100
                        if lineNumber == 2 || lineNumber == 3 {
                            self.fetchCongestionData(complitionHandler: { result in
                                switch result {
                                case let .success(result):
                                    print(self.arrivalSectionViewData)
                                case let .failure(error):
                                    debugPrint(error.localizedDescription)
                                }
                            })
                        }
                        
                        if self.stationDetailView == nil {
                            self.presentStationDetailView(stationCode: stationCode)
                        } else {
                            let stationDetailViewTag = self.view.viewWithTag(100)
                            stationDetailViewTag?.removeFromSuperview()
                            self.presentStationDetailView(stationCode: stationCode)
                        }
                    case let .failure(error):
                        debugPrint(error.localizedDescription)
                    }
                })
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    @objc private func dismissStationDetailView(_ notification: Notification) {
        if self.stationDetailView != nil {
            self.stationDetailView?.removeFromSuperview()
        }
    }
}

private extension MainViewController {
    func setUp() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            MainViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
        
        typealias UIViewControllerType = UIViewController
    }
}
