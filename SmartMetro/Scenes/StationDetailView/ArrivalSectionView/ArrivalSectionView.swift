//
//  ArrivalSectionView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/27.
//

import UIKit
import SnapKit
import SwiftUI

final class ArrivalSectionView: UIView {
    private var arrivalSectionViewData: [ArrivalData.RealTimeArrival] = []
    
    private var northBoundLineDataList: [ArrivalData.RealTimeArrival] = []
    private var southBoundLineDataList: [ArrivalData.RealTimeArrival] = []
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        let northBoundLineArrivalDetailView = ArrivalDetailView(arrivalData: northBoundLineDataList)
        let southBoundLineArrivalDetailView = ArrivalDetailView(arrivalData: southBoundLineDataList)
        southBoundLineArrivalDetailView.setContentCompressionResistancePriority(.defaultHigh ,for: .horizontal)
        let vertivalSeparatorView = VerticalSeparatorView()
        
        [northBoundLineArrivalDetailView, vertivalSeparatorView, southBoundLineArrivalDetailView].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    init(arrivalSectionViewData: [ArrivalData.RealTimeArrival]) {
        self.arrivalSectionViewData = arrivalSectionViewData
        
        print(self.arrivalSectionViewData)
        super.init(frame: .zero)
        
        self.saveDestinationData()
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func saveDestinationData() {
        for data in arrivalSectionViewData {
            switch data.direction {
            case "외선", "상행":
                self.northBoundLineDataList.append(data)
            case "내선", "하행":
                self.southBoundLineDataList.append(data)
            default:
                break
            }
        }
    }
}

private extension ArrivalSectionView {
    func setUp() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.arrangedSubviews[0].snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        stackView.arrangedSubviews[1].snp.makeConstraints {
            $0.width.equalTo(1.0)
            $0.leading.equalTo(stackView.arrangedSubviews[0].snp.trailing)
        }
        
        stackView.arrangedSubviews[2].snp.makeConstraints {
            $0.leading.equalTo(stackView.arrangedSubviews[1].snp.trailing).offset(16.0)
        }
    }
}
