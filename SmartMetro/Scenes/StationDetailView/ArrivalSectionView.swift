//
//  ArrivalSectionView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/23.
//

import UIKit
import SnapKit
import SwiftUI

final class ArrivalSectionView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        let one = ArrivalDetailSectionView()
        let two = ArrivalDetailSectionView()
        let verticalSeparatorView = VerticalSeparatorView()
        
        [one, verticalSeparatorView, two].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ArrivalSectionView {
    func setUp() {
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview()}
        
        stackView.arrangedSubviews[2].snp.makeConstraints {
            $0.centerY.equalTo(stackView.snp.centerY)
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
