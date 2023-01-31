//
//  MainViewController.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/14.
//

import UIKit
import SnapKit
import SwiftUI
import Alamofire

final class MainViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let frameSize = view.bounds.size
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
        
        imageView.image = image
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    // Sample Button
    private lazy var sadangButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 653.0, y: 687.0, width: 30, height: 30))
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.tag = 150 // 사당역 코드
        
        button.addTarget(self, action: #selector(tapStationButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var bangbaeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 682.0, y: 687.0, width: 25.0, height: 30))
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.tag = 149 // 방배역 코드
        
        button.addTarget(self, action: #selector(tapStationButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    @objc func tapStationButton(_ sender: UIButton) {
        let view = view.viewWithTag(1)
        if view == nil {
            let stationDetailView = StationDetailView(stationCode: sender.tag)
            self.view.addSubview(stationDetailView)
            stationDetailView.tag = 1
            stationDetailView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        } else {
            view?.removeFromSuperview() //View를 지우고 새로 그린다???
            
            let stationDetailView = StationDetailView(stationCode: sender.tag)
            self.view.addSubview(stationDetailView)
            stationDetailView.tag = 1
            stationDetailView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    @objc func tapImageView(_ sender: UIImageView) {
        let view = view.viewWithTag(1)
        if view != nil {
            view?.removeFromSuperview()
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        metroMapImageView
    }
}

private extension MainViewController {
    func setUp() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        scrollView.addSubview(metroMapImageView)
        metroMapImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [sadangButton, bangbaeButton].forEach { metroMapImageView.addSubview($0) }
    }
}

struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            MainViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
        
        typealias UIViewControllerType = UIViewController
    }
}
