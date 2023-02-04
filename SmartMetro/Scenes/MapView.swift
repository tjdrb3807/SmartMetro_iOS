//
//  MapView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/02/01.
//

import UIKit
import SnapKit
import SwiftUI

final class MapView: UIView {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let frameSize = UIScreen.main.bounds.size
        
        scrollView.frame = CGRect(origin: .zero, size: frameSize)
        
        // 스크롤바 안보이게 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // 줌인/아웃 최대, 최소 사이즈 설정
        scrollView.minimumZoomScale = 0.7
        scrollView.maximumZoomScale = 2.5
        scrollView.delegate = self
        
        // 시작 화면을 이미지 중앙으로 설정
        let x: CGFloat = ((metroMapImageView.image?.size.width ?? 0) / 2) - (scrollView.frame.width / 2)
        let y: CGFloat = ((metroMapImageView.image?.size.height ?? 0) / 2) - (scrollView.frame.height / 2)

        DispatchQueue.main.async {
            scrollView.contentOffset = CGPoint.init(x: x, y: y)
        }
        
        return scrollView
    }()
    
    private lazy var metroMapImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(imageLiteralResourceName: "img_metro")
        
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    // Sample Button
    private lazy var sadangButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 653.0, y: 687.0, width: 30, height: 30))
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.tag = 226 // 사당역 코드
        button.addTarget(self, action: #selector(tapStationButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var bangbaeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 682.0, y: 687.0, width: 25.0, height: 30))
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.tag = 225 // 방배역 코드
        button.addTarget(self, action: #selector(tapStationButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var leeSuButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 655.0, y: 640.0, width: 30.0, height: 30))
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.tag = 432 // 방배역 코드
        button.addTarget(self, action: #selector(tapStationButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapStationButton(_ sender: UIButton) {
        let x = sender.frame.origin.x - (UIScreen.main.bounds.width / 2)
        let y = sender.frame.origin.y - (UIScreen.main.bounds.height / 2)
        self.scrollView.contentOffset = CGPoint.init(x: x, y: y)
        
        NotificationCenter.default.post(name: NSNotification.Name("tapStationButton"),
                                        object: sender.tag)
    }
}

extension MapView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        metroMapImageView
    }
}

private extension MapView {
    func setUp() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(metroMapImageView)
        metroMapImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        [sadangButton, bangbaeButton, leeSuButton].forEach { metroMapImageView.addSubview($0) }
    }
}

