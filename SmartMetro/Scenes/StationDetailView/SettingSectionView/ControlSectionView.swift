//
//  ControlSectionView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/19.
//

import UIKit
import SnapKit
import SwiftUI

final class ControlSectionView: UIView {
    private var lineList: [StationLineInfoData] // Max: 10개
    private var spacingViewCount: Int
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        for lineInfo in lineList {
            let button = UIButton()
            let color = UIColor.setColor(lineNumber: Int(lineInfo.stationCode.prefix(2))!)
            
            button.tintColor = color
            button.tag = Int(lineInfo.stationCode)!
            button.addTarget(self, action: #selector(tapLineButton(_:)), for: .touchUpInside)
            
            if lineInfo.isChecked {
                button.setImage(systemName: "\(Int(lineInfo.stationCode.prefix(2))!).circle.fill")
                // Tap 제스처 막기 필요
            } else {
                button.setImage(systemName: "\(Int(lineInfo.stationCode.prefix(2))!).circle")
            }

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
    
    init(lineList: [StationLineInfoData]) {
        self.lineList = lineList
        self.spacingViewCount = 10 - lineList.count
        super.init(frame: .zero)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapLineButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("tapLineButton"),
                                        object: sender.tag)
    }
}

private extension ControlSectionView {
    func setUp() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

struct ControlSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            ControlSectionView(lineList: [
                StationLineInfoData(stationCode: "0226", isChecked: true),
                StationLineInfoData(stationCode: "0443", isChecked: false)
            ])
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
