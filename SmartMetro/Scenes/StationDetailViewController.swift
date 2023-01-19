//
//  StationDetailViewController.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/14.
//

import UIKit
import SnapKit
import SwiftUI
import Alamofire

final class StationDetailViewController: UIViewController {
    private var stationCode: Int
    private var stationInfo: [StationResponseModel.Station] = []
    private var realtimeArrivalList: [StationArrivalDataResponseModel.RealTimeArrival] = []
    
    private lazy var currentStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "현재역"
        label.font = .systemFont(ofSize: 35.0, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .green
        
        return label
    }()
    
    private lazy var beforeStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이전역"
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .green
        
        return label
    }()
    
    private lazy var afterStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "다음역"
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .green
        
        return label
    }()
    
    private lazy var northBoundLineLabel: UILabel = {
        let label = UILabel()
        label.text = "상행선"
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var arrivalTiemLabel: UILabel = {
        let label = UILabel()
        label.text = "1분 50초"
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .orange
        
        return label
    }()
    
    init(stationCode: Int) {
        self.stationCode = stationCode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.fetchStationInfoData(complitionHandler: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(result):
                self.stationInfo = result.stationInfo
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
            
            //MARK: 이게 최선???
            self.fetchStationArrivalData(complitionHandler: { result in
                switch result {
                case let .success(result):
                    print(result)
                    self.realtimeArrivalList = result.realtimeArrivalList
                    print(self.realtimeArrivalList)
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
                self.setUp()
            })
        })
    }
    
    private func fetchStationInfoData(complitionHandler: @escaping (Result<StationResponseModel, Error>) -> Void) {
        let url = "http://127.0.0.1:8080/api/v2/stations/\(stationCode)"
        
        AF.request(url, method: .get)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(StationResponseModel.self, from: data)
                        complitionHandler(.success(result))
                    } catch {
                        complitionHandler(.failure(error))
                    }
                case let .failure(error):
                    complitionHandler(.failure(error))
                }
            })
    }
    
    private func fetchStationArrivalData(complitionHandler: @escaping (Result<StationArrivalDataResponseModel, Error>) -> Void) {
        let url = "http://swopenAPI.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(self.stationInfo[0].stationName)"
        
        AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", method: .get)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(StationArrivalDataResponseModel.self, from: data)
                        complitionHandler(.success(result))
                    } catch {
                        complitionHandler(.failure(error))
                    }
                case let .failure(error):
                    complitionHandler(.failure(error))
                }
            })
    }
}

extension StationDetailViewController {
    func setUp() {
        [beforeStationNameLabel, currentStationNameLabel, afterStationNameLabel, northBoundLineLabel, arrivalTiemLabel].forEach { view.addSubview($0) }
        
        beforeStationNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50.0)
            $0.leading.equalToSuperview().inset(10.0)
        }
        
        currentStationNameLabel.snp.makeConstraints {
            $0.top.equalTo(beforeStationNameLabel.snp.top)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        afterStationNameLabel.snp.makeConstraints {
            $0.top.equalTo(currentStationNameLabel.snp.top)
            $0.trailing.equalToSuperview().inset(10.0)
        }
        
        northBoundLineLabel.snp.makeConstraints {
            $0.top.equalTo(currentStationNameLabel.snp.bottom).offset(20.0)
            $0.leading.equalTo(beforeStationNameLabel.snp.leading)
        }
        
        arrivalTiemLabel.snp.makeConstraints {
            $0.top.equalTo(northBoundLineLabel.snp.top)
            $0.leading.equalTo(northBoundLineLabel.snp.trailing).offset(10.0)
        }
        
        currentStationNameLabel.text = self.stationInfo[0].stationName
        beforeStationNameLabel.text = self.stationInfo[0].beforeStationName
        afterStationNameLabel.text = self.stationInfo[0].afterStationName
        northBoundLineLabel.text = self.realtimeArrivalList[0].line
        arrivalTiemLabel.text = self.realtimeArrivalList[0].remainTime
    }
}

//struct StationDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        Container()
//    }
//
//    struct Container: UIViewControllerRepresentable {
//        func makeUIViewController(context: Context) -> UIViewController {
//            StationDetailViewController(stationCode: 149)
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//
//        typealias UIViewControllerType = UIViewController
//    }
//}
