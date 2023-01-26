//
//  ArrivalDetailSectionView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/23.
//

import UIKit
import SnapKit
import SwiftUI

final class ArrivalDetailSectionView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        let spacingView01 = UIView()
        spacingView01.backgroundColor = .red
        
        let firstArrivalDetaView = ArrivalDataView(destination: "상행선", realtiem: "곧 도착")
        firstArrivalDetaView.backgroundColor = .brown
        
        let secondArrivalDataView = ArrivalDataView(destination: "상행선", realtiem: "12분 후 도착")
        secondArrivalDataView.backgroundColor = .blue
        
        
        let spacingView02 = UIView()
        spacingView02.backgroundColor = .green
        
        [spacingView01, firstArrivalDetaView, secondArrivalDataView, spacingView02].forEach { stackView.addArrangedSubview($0) }
        
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

private extension ArrivalDetailSectionView {
    func setUp() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

struct ArrivalDetailSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            ArrivalDetailSectionView()
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
