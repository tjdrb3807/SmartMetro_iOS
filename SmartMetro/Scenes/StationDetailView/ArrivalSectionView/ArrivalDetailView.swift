//
//  ArrivalDetailView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/27.
//

import UIKit
import SnapKit
import SwiftUI

final class ArrivalDetailView: UIView {
    private var arrivalData: [ArrivalData.RealTimeArrival] = []

    private let firstArrivalDirection: String
    private let firstArrivalDestination: String
    private let firstArrivalRealtime: String
    private let secondArrivalDirection: String
    private let secondArrivalDestination: String
    private let secondArrivalRealtime: String
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        let firstArrivalDataView = ArrivalDataView(direction: firstArrivalDirection, destination: firstArrivalDestination, realtiem: firstArrivalRealtime)
        let secondArrivalDataView = ArrivalDataView(direction: secondArrivalDirection, destination: secondArrivalDestination, realtiem: secondArrivalRealtime)
        
        [firstArrivalDataView, secondArrivalDataView].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    init(arrivalData: [ArrivalData.RealTimeArrival]) {
        self.arrivalData = arrivalData
        self.firstArrivalDirection = arrivalData[0].direction
        self.firstArrivalDestination = arrivalData[0].destination
        self.firstArrivalRealtime = arrivalData[0].remainTime
        
        self.secondArrivalDirection = arrivalData[1].direction
        self.secondArrivalDestination = arrivalData[1].destination
        self.secondArrivalRealtime = arrivalData[1].remainTime
        
        super.init(frame: .zero)
        self.setUP()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArrivalDetailView {
    func setUP() {
       addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        stackView.arrangedSubviews[1].snp.makeConstraints {
            $0.top.equalTo(stackView.arrangedSubviews[0].snp.bottom)
        }
    }
}

struct ArrivalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            ArrivalDetailView(arrivalData: [ArrivalData.RealTimeArrival(stationCode: "1004000226", direction: "외선", destination: "성수행 - 방배방면", remainTime: "사당 도착", stationLineNumber: "1002", lineList: "1002,1004")])
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
