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
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        let northBoundLineArrivalDetailView = ArrivalDetailView(firstArrivalDestination: "상행선", firstArrivalRealtime: "곧 도착", secondArrivalDestination: "상행성", secondArrivalRealtime: "12분 후 도착")
        let southBoundLineArrivalDetailView = ArrivalDetailView(firstArrivalDestination: "하행선", firstArrivalRealtime: "2분 후 도착", secondArrivalDestination: "내부 순환선", secondArrivalRealtime: "8분 후 도착")
        southBoundLineArrivalDetailView.setContentCompressionResistancePriority(.defaultHigh ,for: .horizontal)
        let vertivalSeparatorView = VerticalSeparatorView()
        
        [northBoundLineArrivalDetailView, vertivalSeparatorView, southBoundLineArrivalDetailView].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

struct ArrivalSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            ArrivalSectionView()
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
