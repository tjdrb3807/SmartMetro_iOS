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
    private let lineList: [Int] = [2, 4, 7, 11]
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
        
        var inset: CGFloat = 16.0
        let buttonSize: CGFloat = 35.0
        for lineNumber in lineList {
            let button = UIButton()
            button.tag = lineNumber
            
            switch lineNumber {
            case 1:
                button.tintColor = .blue
            case 2:
                button.tintColor = .green
            case 4:
                button.tintColor = .red
            default:
                break
            }
            
            if lineNumber == lineList[0] {
                button.setImage(systemName: "\(lineNumber).circle.fill")
                
                stackView.addSubview(button)
                button.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(16.0)
                    $0.leading.equalToSuperview().inset(inset)
                    $0.width.height.equalTo(buttonSize)
                }
            } else {
                button.setImage(systemName: "\(lineNumber).circle")
                
                stackView.addSubview(button)
                button.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(16.0)
                    $0.leading.equalToSuperview().inset(inset)
                    $0.width.height.equalTo(buttonSize)
                }
            }
            inset += 40.0
        }
        
        let dataReloadButton = UIButton()
        dataReloadButton.setImage(systemName: "repeat.circle")
        
        let popButton = UIButton()
        popButton.setImage(systemName: "xmark")
        
        [dataReloadButton, popButton].forEach { stackView.addSubview($0) }
        
        popButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.width.height.equalTo(buttonSize)
        }
        
        dataReloadButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.trailing.equalTo(popButton.snp.leading).offset(-5.0)
            $0.width.height.equalTo(buttonSize)
        }
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(67.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct SettingSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            SettingSectionView(frame: .zero)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
