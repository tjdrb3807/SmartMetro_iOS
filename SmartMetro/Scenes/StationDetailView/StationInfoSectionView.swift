//
//  StationInfoSectionView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/19.
//

import UIKit
import SnapKit
import SwiftUI

final class StationInfoSectionView: UIView {
    private lazy var currentStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "사당"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.green.cgColor
        label.layer.borderWidth = 10.0
        label.layer.cornerRadius = 30.0
        
        return label
    }()
    
    private lazy var beforeStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "❮ 낙성대"
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.0)
        label.layer.backgroundColor = UIColor.green.cgColor
        label.layer.cornerRadius = 10.0
        
        return label
    }()
    
    private lazy var afterStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "방배 ❯"
        label.font = .systemFont(ofSize: 17.0)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.backgroundColor = UIColor.green.cgColor
        label.layer.cornerRadius = 10.0

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StationInfoSectionView {
    func setUp() {
        [currentStationNameLabel, beforeStationNameLabel, afterStationNameLabel].forEach { addSubview($0) }
        
        currentStationNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.width.equalTo(170.0)
            $0.height.equalTo(60.0)
            $0.centerX.equalToSuperview()
        }
        
        beforeStationNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(currentStationNameLabel.snp.centerY)
            $0.leading.equalToSuperview().inset(16.0)
            $0.width.equalTo(105.0)
        }

        afterStationNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(currentStationNameLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.width.equalTo(105.0)
        }
    }
}

struct StationInfoSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            StationInfoSectionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
        
        typealias UIViewType = UIView
    }
}
