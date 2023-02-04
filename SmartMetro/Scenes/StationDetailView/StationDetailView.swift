//
//  StationDetailView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/14.
//

import UIKit
import SnapKit
import SwiftUI

class StationDetailView: UIView {
    private var controlSectionViewData: [StationLineInfoData]
    private var stationInfoSectionViewData: [StationInfoData.Station]
    private var arrivalSectionViewData: [ArrivalData.RealTimeArrival]
        
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 16.0, bottom: 0.0, right: 16.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let controlSectionView = ControlSectionView(controlSectionViewData: controlSectionViewData)
        let horizontalSeparatorView = HorizontalSeparatorView()
        let stationInfoSectionView = StationInfoSectionView(stationInfoSectionViewData: stationInfoSectionViewData[0])
        let arrivalSectionView = ArrivalSectionView(arrivalSectionViewData: arrivalSectionViewData)
        let spacingView = UIView()

        [controlSectionView, horizontalSeparatorView, stationInfoSectionView, arrivalSectionView, spacingView].forEach { stackView.addArrangedSubview($0) }
    
        stackView.setCustomSpacing(8.0, after: controlSectionView)
        stackView.setCustomSpacing(8.0, after: horizontalSeparatorView)
        stackView.setCustomSpacing(8.0, after: stationInfoSectionView)
        
        return stackView
    }()
    
    init(controlSectionViewData: [StationLineInfoData], stationInfoSectionViewData: [StationInfoData.Station], arrivalSectionViewData: [ArrivalData.RealTimeArrival]) {
        self.controlSectionViewData = controlSectionViewData
        self.stationInfoSectionViewData = stationInfoSectionViewData
        self.arrivalSectionViewData = arrivalSectionViewData
        
        super.init(frame: .zero)
        backgroundColor = .white
        
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
