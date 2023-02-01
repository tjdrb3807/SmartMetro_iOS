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

final class StationDetailView: UIView {
    private var stationCode: Int
    private var stationInfo: [StationInfoData.Station] = []
    private var realtimeArrivalList: [ArrivalData.RealTimeArrival] = []
    private var stationLineInfoDataList: [StationLineInfoData] = []
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 16.0, bottom: 0.0, right: 16.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let controlSectionView = ControlSectionView(lineList: stationLineInfoDataList)
        controlSectionView.tag = 100
        let horizontalSeparatorView = HorizontalSeparatorView()
        let stationInfoSectionView = StationInfoSectionView(stationInfo: stationInfo[0])
        let arrivalSectionView = ArrivalSectionView()
        let spacingView = UIView()

        [controlSectionView, horizontalSeparatorView, stationInfoSectionView, arrivalSectionView, spacingView].forEach { stackView.addArrangedSubview($0) }
        
        
        stackView.setCustomSpacing(8.0, after: controlSectionView)
        stackView.setCustomSpacing(8.0, after: horizontalSeparatorView)
        stackView.setCustomSpacing(8.0, after: stationInfoSectionView)
        
        return stackView
    }()
    
    init(stationCode: Int) {
        self.stationCode = stationCode
        super.init(frame: .zero)
        
        self.backgroundColor = .white
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
                    self.realtimeArrivalList = result.realtimeArrivalList
                    self.saveData()
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    print(result)
                    print("여기가 문제?")
                }
                self.setUp()
            })
        })
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tapLineButton(_:)),
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
        let url = "http://swopenAPI.seoul.go.kr/api/subway/584c557a7a746a64313238637a596343/json/realtimeStationArrival/0/1/\(self.stationInfo[0].stationName)"
        
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
    
    private func saveData() {
        let list: [Int] = self.realtimeArrivalList[0].lineList.components(separatedBy: ",").map { Int($0.suffix(2))! }
        var isChecked: Bool = true
        
        for lineNumber in list {
            let data = StationLineInfoData(lineNumber: lineNumber, isChecked: isChecked)
            self.stationLineInfoDataList.append(data)
            isChecked = false
        }
    }
    
    @objc private func tapLineButton(_ notification: Notification) {
        guard let data = notification.object as? [StationLineInfoData] else { return }
        self.stationLineInfoDataList = data
        stackView.viewWithTag(100)?.removeFromSuperview()
        let controlSectionView = ControlSectionView(lineList: stationLineInfoDataList)
        stackView.addArrangedSubview(controlSectionView)
        
    }
}

extension StationDetailView {
    func setUp() {
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

struct StationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }

    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            StationDetailView(stationCode: 150)
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}

        typealias UIViewType = UIView
    }
}
