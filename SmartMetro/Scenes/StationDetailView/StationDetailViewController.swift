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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        let settingSectionView = SettingSectionView(lineList: [1, 2, 3, 4, 5])
        let horizontalSeparatorView = HorizontalSeparatorView()
        let stationInfoSectionView = StationInfoSectionView()
        
        [settingSectionView, horizontalSeparatorView, stationInfoSectionView].forEach { stackView.addSubview($0) }
        
        settingSectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50.0)
        }
        
        horizontalSeparatorView.snp.makeConstraints {
            $0.top.equalTo(settingSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        stationInfoSectionView.snp.makeConstraints {
            $0.top.equalTo(horizontalSeparatorView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        return stackView
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
//        self.fetchStationInfoData(complitionHandler: { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case let .success(result):
//                self.stationInfo = result.stationInfo
//            case let .failure(error):
//                debugPrint(error.localizedDescription)
//            }
//
//            //MARK: 이게 최선???
//            self.fetchStationArrivalData(complitionHandler: { result in
//                switch result {
//                case let .success(result):
//                    self.realtimeArrivalList = result.realtimeArrivalList
//                case let .failure(error):
//                    debugPrint(error.localizedDescription)
//                }
//                self.setUp()
//            })
//        })
        self.setUp()
    }
    
    private func fetchStationInfoData(complitionHandler: @escaping (Result<StationResponseModel, Error>) -> Void) {
        let url = "http://192.168.0.8:8080/api/v2/stations/\(stationCode)"
        
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
        let url = "http://swopenAPI.seoul.go.kr/api/subway/584c557a7a746a64313238637a596343/json/realtimeStationArrival/0/5/\(self.stationInfo[0].stationName)"
        
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
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

struct StationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }

    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            StationDetailViewController(stationCode: 149)
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

        typealias UIViewControllerType = UIViewController
    }
}
