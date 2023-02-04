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
    private let stationInfoSectionViewData: StationInfoData.Station
    private var lineNumber: Int
    
    private lazy var currentStationNameLabel: UILabel = {
        let label = UILabel()
    
        label.text = stationInfoSectionViewData.stationName
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
    
    private lazy var northBoundStationNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = " ❮ \(stationInfoSectionViewData.beforeStationName)"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        label.layer.backgroundColor = UIColor.setColor(lineNumber: self.lineNumber).cgColor
        label.layer.cornerRadius = 10.0
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return label
    }()
    
    private lazy var southBoundStationNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "\(stationInfoSectionViewData.afterStationName) ❯"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14.0)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.backgroundColor = UIColor.setColor(lineNumber: self.lineNumber).cgColor
        label.layer.cornerRadius = 10.0
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        return label
    }()
    
    init(stationInfoSectionViewData: StationInfoData.Station) {
        self.stationInfoSectionViewData = stationInfoSectionViewData
        self.lineNumber = stationInfoSectionViewData.stationCode / 100
        super.init(frame: .zero)
        
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StationInfoSectionView {
    func setUp() {
        [northBoundStationNameLabel, southBoundStationNameLabel, currentStationNameLabel].forEach { addSubview($0) }
        
        currentStationNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(170.0)
            $0.height.equalTo(50.0)
        }
        
        northBoundStationNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(currentStationNameLabel.snp.leading).offset(2.0)
            $0.centerY.equalTo(currentStationNameLabel.snp.centerY)
        }
        
        southBoundStationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(currentStationNameLabel.snp.trailing).offset(-2.0)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(currentStationNameLabel.snp.centerY)
        }
    }
}
