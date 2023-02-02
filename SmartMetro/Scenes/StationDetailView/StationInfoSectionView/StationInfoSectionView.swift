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
    private let stationInfo: StationInfoData.Station
    private var lineNumber: Int
    
    private lazy var currentStationNameLabel: UILabel = {
        let label = UILabel()
    
        label.text = stationInfo.stationName
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.layer.backgroundColor = UIColor.white.cgColor
        label.layer.borderWidth = 5.0
        label.layer.cornerRadius = 25.0
        label.layer.borderColor = UIColor.setColor(lineNumber: self.lineNumber).cgColor
        
        return label
    }()
    
    private lazy var beforeStationNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = " ❮ \(stationInfo.beforeStationName)"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        label.layer.backgroundColor = UIColor.setColor(lineNumber: self.lineNumber).cgColor
        label.layer.cornerRadius = 10.0
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return label
    }()
    
    private lazy var afterStationNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "\(stationInfo.afterStationName) ❯"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14.0)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.backgroundColor = UIColor.setColor(lineNumber: self.lineNumber).cgColor
        label.layer.cornerRadius = 10.0
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        return label
    }()
    
    init(stationInfo: StationInfoData.Station) {
        self.stationInfo = stationInfo
        self.lineNumber = stationInfo.stationCode / 100
        super.init(frame: .zero)
        
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StationInfoSectionView {
    func setUp() {
        [beforeStationNameLabel, afterStationNameLabel, currentStationNameLabel].forEach { addSubview($0) }
        
        currentStationNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(170.0)
            $0.height.equalTo(50.0)
        }
        
        beforeStationNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(currentStationNameLabel.snp.leading).offset(2.0)
            $0.centerY.equalTo(currentStationNameLabel.snp.centerY)
        }
        
        afterStationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(currentStationNameLabel.snp.trailing).offset(-2.0)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(currentStationNameLabel.snp.centerY)
        }
    }
}

struct StationInfoSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            StationInfoSectionView(stationInfo: StationInfoData.Station(stationCode: 226, stationName: "사당", beforeStationName: "낙성대", afterStationName: "방배", stationLineCode: "0226,0227"))
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
