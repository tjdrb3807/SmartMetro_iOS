//
//  SettingSectionView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/19.
//

import UIKit
import SnapKit
import SwiftUI

final class SettingSectionView: UIView {
    private var lineList: [Int] // Max: 10개
    private var spacingViewCount: Int
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    
        for lineNumber in lineList {
            let button = UIButton()
            let color = UIColor().setColor(lineNumber: lineNumber)
            button.tintColor = color
            button.tag = lineNumber
            
            if lineNumber == lineList.first {
                button.setImage(systemName: "\(lineNumber).circle.fill")
            } else {
                button.setImage(systemName: "\(lineNumber).circle")
            }
            
            button.tag = lineNumber
            //TODO: Button AddTarget() 구현
            stackView.addArrangedSubview(button)
        }
        
        if spacingViewCount > 0 {
            for _ in 1...spacingViewCount {
                let spacingView = UIView()
                spacingView.backgroundColor = .white
                stackView.addArrangedSubview(spacingView)
            }
        }
        
    
        let dataReloadButton = UIButton()
        dataReloadButton.setImage(systemName: "arrow.triangle.2.circlepath")

        let popButton = UIButton()
        popButton.setImage(systemName: "xmark")

        [dataReloadButton, popButton].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    init(lineList: [Int]) {
        self.lineList = lineList
        self.spacingViewCount = 10 - lineList.count
        super.init(frame: .zero)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingSectionView {
    func setUp() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

struct SettingSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            SettingSectionView(lineList: [1, 2, 3, 4, 5, 6, 7, 8, 9])
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
