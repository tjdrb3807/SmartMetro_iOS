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
    private var stationInfo: [StationInfoData.Station] = []
    private var realtimeArrivalList: [ArrivalData.RealTimeArrival] = []
    
    private lazy var mapView = MapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tapStationButton(_:)),
                                               name: NSNotification.Name("tapStationButton"),
                                               object: nil)
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
        let url = "http://swopenAPI.seoul.go.kr/api/subway/584c557a7a746a64313238637a596343/json/realtimeStationArrival/0/1/\(self.stationInfo[0].stationName)"
        
        AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", method: .get)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ArrivalData.self, from: data)
                        complitionHandler(.success(result))
                        let stationView = StationDetailView(stationCode: self.stationCode)
                        self.view.addSubview(stationView)
                        stationView.snp.makeConstraints {
                            $0.width.equalToSuperview()
                            $0.bottom.equalToSuperview()
                        }
                    } catch {
                        complitionHandler(.failure(error))
                    }
                case let .failure(error):
                    complitionHandler(.failure(error))
                }
            })
    }
    
    @objc private func tapStationButton(_ notification: Notification) {
        guard let stationCode = notification.object as? Int else { return }
        
        self.stationCode = stationCode
        self.fetchStationInfoData(complitionHandler: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(result):
                self.stationInfo = result.stationInfo
                self.fetchStationArrivalData(complitionHandler: { result in
                    switch result {
                    case let .success(result):
                        self.realtimeArrivalList = result.realtimeArrivalList
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
