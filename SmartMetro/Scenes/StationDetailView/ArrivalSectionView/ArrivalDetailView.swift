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
    private let firstArrivalDestination: String
    private let firstArrivalRealtime: String
    private let secondArrivalDestination: String
    private let secondArrivalRealtime: String
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        let firstArrivalDataView = ArrivalDataView(destination: firstArrivalDestination, realtiem: firstArrivalRealtime)
        let secondArrivalDataView = ArrivalDataView(destination: secondArrivalDestination, realtiem: secondArrivalRealtime)
        
        [firstArrivalDataView, secondArrivalDataView].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    init(firstArrivalDestination: String, firstArrivalRealtime: String, secondArrivalDestination: String, secondArrivalRealtime: String) {
        self.firstArrivalDestination = firstArrivalDestination
        self.firstArrivalRealtime = firstArrivalRealtime
        self.secondArrivalDestination = secondArrivalDestination
        self.secondArrivalRealtime = secondArrivalRealtime
        
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
            ArrivalDetailView(firstArrivalDestination: "상행선", firstArrivalRealtime: "곧 도착", secondArrivalDestination: "상행선", secondArrivalRealtime: "12분 후 도착")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
