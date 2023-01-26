//
//  StationInfoSectionView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/19.
//

import UIKit
import SnapKit
import SwiftUI

final class StationInfoSectionView: UIView {
    private let stationInfo: StationResponseModel.Station
    
    private lazy var currentStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "사당"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.layer.backgroundColor = UIColor.white.cgColor
        label.layer.borderColor = UIColor(red: 96/255, green: 176/255, blue: 87/255, alpha: 1.0).cgColor
        label.layer.borderWidth = 5.0
        label.layer.cornerRadius = 22.0
        
        return label
    }()
    
    private lazy var beforeStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "❮ 방배"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        label.layer.backgroundColor = UIColor(red: 96/255, green: 176/255, blue: 87/255, alpha: 1.0).cgColor
        label.layer.cornerRadius = 10.0
        
        return label
    }()
    
    private lazy var afterStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "낙성대 ❯"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14.0)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.backgroundColor = UIColor(red: 96/255, green: 176/255, blue: 87/255, alpha: 1.0).cgColor
        label.layer.cornerRadius = 10.0

        return label
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setUp()
//    }
    init(stationInfo: StationResponseModel.Station) {
        self.stationInfo = stationInfo
        super.init(frame: .zero)
        
        self.setUp()
        self.currentStationNameLabel.text = stationInfo.stationName
        self.beforeStationNameLabel.text = "❮ \(stationInfo.beforeStationName)"
        self.afterStationNameLabel.text = "\(stationInfo.afterStationName) ❯"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StationInfoSectionView {
    func setUp() {
        [beforeStationNameLabel, afterStationNameLabel, currentStationNameLabel].forEach { addSubview($0) }
        
        currentStationNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.width.equalTo(170.0)
            $0.height.equalTo(45.0)
            $0.centerX.equalToSuperview()
        }
        
        beforeStationNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(currentStationNameLabel.snp.centerY)
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalTo(currentStationNameLabel.snp.leading).offset(10)
            $0.height.equalTo(20.0)
        }

        afterStationNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(currentStationNameLabel.snp.centerY)
            $0.leading.equalTo(currentStationNameLabel.snp.trailing).offset(-10.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(20.0)
        }
    }
}

struct StationInfoSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            StationInfoSectionView(stationInfo: StationResponseModel.Station(stationName: "사당", stationLineNumber: 2, beforeStationName: "낙성대", afterStationName: "방배"))
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
