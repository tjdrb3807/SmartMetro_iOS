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
    private lazy var mapView = MapView()
    
    private var stationDetailView: StationDetailView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tapStationButton(_:)),
                                               name: NSNotification.Name("tapStationButton"),
                                               object: nil)
    }
    
    private func presentStationDetailView(stationCode: Int) {
        self.stationDetailView = StationDetailView(stationCode: stationCode)
        view.addSubview(stationDetailView!)
        stationDetailView?.tag = 100
        stationDetailView!.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc private func tapStationButton(_ notification: Notification) {
        guard let stationCode = notification.object as? Int else { return }
        
        if stationDetailView == nil {
            self.presentStationDetailView(stationCode: stationCode)
        } else {
            let stationDetailViewTag = self.view.viewWithTag(100)
            stationDetailViewTag?.removeFromSuperview()
            self.presentStationDetailView(stationCode: stationCode)
        }
    }
}

private extension MainViewController {
    func setUp() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
