//
//  LineButtonView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/02/05.
//

import UIKit
import SnapKit

final class LineButtonView: UIView {
    private var controlSectionViewData: [StationLineInfoData]
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
        
        return stackView
    }()
    
    init(controlSectionViewData: [StationLineInfoData]) {
        self.controlSectionViewData = controlSectionViewData
        self.spacingViewCount = 10 - self.controlSectionViewData.count
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
}

private extension LineButtonView {
    func setUp() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
