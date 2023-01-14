//
//  StationDetailViewController.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/14.
//

import UIKit
import SnapKit
import SwiftUI

final class StationDetailViewController: UIViewController {
    private lazy var currentStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "현재역"
        label.font = .systemFont(ofSize: 35.0, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .green
        
        return label
    }()
    
    private lazy var beforeStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이전역"
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .green
        
        return label
    }()
    
    private lazy var afterStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "다음역"
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .green
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setUp()
    }
}

extension StationDetailViewController {
    func setUp() {
        [beforeStationNameLabel, currentStationNameLabel, afterStationNameLabel].forEach { view.addSubview($0) }
        
        beforeStationNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50.0)
            $0.leading.equalToSuperview().inset(10.0)
        }
        
        currentStationNameLabel.snp.makeConstraints {
            $0.top.equalTo(beforeStationNameLabel.snp.top)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        afterStationNameLabel.snp.makeConstraints {
            $0.top.equalTo(currentStationNameLabel.snp.top)
            $0.trailing.equalToSuperview().inset(10.0)
        }
        
        
    }
}

struct StationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            StationDetailViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
        
        typealias UIViewControllerType = UIViewController
    }
}
