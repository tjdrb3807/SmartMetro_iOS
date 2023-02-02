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
    private let direction: String
    private let destination: String
    private let realtiem: String
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        let destinationLabel = UILabel()
//        destinationLabel.text = destinationText
        switch self.direction {
        case "상행", "하행":
            destinationLabel.text = "\(destination)행 "
        case "외선", "내선":
            destinationLabel.text = "\(destination)(\(direction)) "
        default:
            break
        }
        
        destinationLabel.font = .systemFont(ofSize: 15.0, weight: .medium)
        
        let realtimeLabel = UILabel()
        realtimeLabel.text = self.realtiem + "  "
        realtimeLabel.font = .systemFont(ofSize: 15.0, weight: .medium)
        realtimeLabel.textColor = .orange
        
        let spacingView = UIView()
        
        [destinationLabel, realtimeLabel].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    init(direction: String, destination: String, realtiem: String) {
        self.direction = direction
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
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(3.0)
        }
        
        stackView.arrangedSubviews[0].setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.arrangedSubviews[1].setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

struct ArrivalDataView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            ArrivalDataView(direction: "상행", destination: "성수", realtiem: "12분 후 도착")
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
