//
//  ArrivalDataView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/23.
//

import UIKit
import SnapKit
import SwiftUI

final class ArrivalDataView: UIView {
    private let destination: String
    private let realtiem: String
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill

        let destinationLabel = UILabel()
        destinationLabel.text = self.destination
        destinationLabel.font = .systemFont(ofSize: 17.0, weight: .medium)
        
        let realtimeLabel = UILabel()
        realtimeLabel.text = self.realtiem
        realtimeLabel.font = .systemFont(ofSize: 17.0, weight: .medium)
        realtimeLabel.textColor = .orange
        
        let spacingView = UIView()
        
        [destinationLabel, realtimeLabel, spacingView].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    init(destination: String, realtiem: String) {
        self.destination = destination
        self.realtiem = realtiem
        
        super.init(frame: .zero)
        
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ArrivalDataView {
    func setUp() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.arrangedSubviews[0].snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        stackView.arrangedSubviews[1].snp.makeConstraints {
            $0.left.equalTo(stackView.arrangedSubviews[0].snp.right).offset(10.0)
        }
    }
}

struct ArrivalDataView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            ArrivalDataView(destination: "상행선", realtiem: "12분 후 도착")
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
