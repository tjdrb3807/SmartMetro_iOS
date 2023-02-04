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
    private var controlSectionViewData: [StationLineInfoData] // Max: 10개
    private var spacingViewCount: Int
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        for data in controlSectionViewData {
            let button = UIButton()
            let color = UIColor.setColor(lineNumber: Int(data.stationCode.prefix(2))!)
            
            button.tintColor = color
            button.tag = Int(data.stationCode)!
            
            if data.isChecked {
                button.setImage(systemName: "\(Int(data.stationCode.prefix(2))!).circle.fill")
            } else {
                button.setImage(systemName: "\(Int(data.stationCode.prefix(2))!).circle")
                button.addTarget(self, action: #selector(tapLineButton(_:)), for: .touchUpInside)
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

        let dismissButton = UIButton()
        dismissButton.setImage(systemName: "xmark")
        dismissButton.addTarget(self, action: #selector(tapDismissButton(_:)), for: .touchUpInside)

        [dataReloadButton, dismissButton].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    init(controlSectionViewData: [StationLineInfoData]) {
        self.controlSectionViewData = controlSectionViewData
        self.spacingViewCount = 10 - controlSectionViewData.count
        super.init(frame: .zero)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapLineButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("tapStationOrLineButton"),
                                        object: sender.tag)
    }
    
    @objc private func tapDismissButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("tapDismissButtonOrImageView"),
                                        object: nil)
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
            ControlSectionView(controlSectionViewData: [
                StationLineInfoData(stationCode: "0226", isChecked: true),
                StationLineInfoData(stationCode: "0443", isChecked: false)
            ])
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
