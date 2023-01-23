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
    
    private lazy var destinationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.text = destination
        
        return label
    }()
    
    private lazy var realtimeLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.text = realtiem
        
        return label
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
        let stackView = UIStackView(arrangedSubviews: [destinationLabel, realtimeLable])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
        
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
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
