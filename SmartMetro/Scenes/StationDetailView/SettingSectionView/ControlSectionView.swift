//
//  ControlSectionView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/19.
//

import UIKit
import SnapKit
import SwiftUI

final class ControlSectionView: UIView {
    private var controlSectionViewData: [StationLineInfoData] // Max: 10개
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally

        let lineButtonView = LineButtonView(controlSectionViewData: controlSectionViewData)
        let operationView = OperationView()

        [lineButtonView, operationView].forEach { stackView.addArrangedSubview($0) }
    
        return stackView
    }()
    
    init(controlSectionViewData: [StationLineInfoData]) {
        self.controlSectionViewData = controlSectionViewData
        super.init(frame: .zero)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ControlSectionView {
    func setUp() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

struct ControlSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            ControlSectionView(controlSectionViewData: [
                StationLineInfoData(stationCode: "0226", isChecked: true),
                StationLineInfoData(stationCode: "0443", isChecked: false)
            ])
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
