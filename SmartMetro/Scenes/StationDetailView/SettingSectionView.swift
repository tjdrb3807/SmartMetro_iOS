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
            button.tag = lineNumber
            

            //TODO: 호선 추가
            switch lineNumber {
            case 1:
                button.tintColor = UIColor(red: 41/255, green: 60/255, blue: 249/222, alpha: 1.0)
            case 2:
                button.tintColor = UIColor(red: 96/255, green: 176/255, blue: 87/255, alpha: 1.0)
            case 3:
                button.tintColor = UIColor(red: 240/255, green: 123/255, blue: 48/255, alpha: 1.0)
            case 4:
                button.tintColor = UIColor(red: 82/255, green: 156/255, blue: 222/255, alpha: 1.0)
            case 5:
                button.tintColor = UIColor(red: 127/255, green: 49/255, blue: 226/255, alpha: 1.0)
            case 6:
                button.tintColor = UIColor(red: 164/255, green: 86/255, blue: 37/255, alpha: 1.0)
            case 7:
                button.tintColor = UIColor(red: 107/255, green: 114/255, blue: 40/255, alpha: 1.0)
            case 8:
                button.tintColor = UIColor(red: 215/255, green: 55/255, blue: 109/255, alpha: 1.0)
            case 9:
                button.tintColor = UIColor(red: 220/255, green: 164/255, blue: 74/255, alpha: 1.0)
            case 10: // 경의 중앙선
                button.tintColor = UIColor(red: 105/255, green: 157/255, blue: 122/255, alpha: 1.0)
            default:
                break
            }
            
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
