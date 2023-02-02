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
    private var stationDetailViewController: StationDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tapStationButton(_:)),
                                               name: NSNotification.Name("tapStationButton"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tapLineButton(_:)),
                                               name: NSNotification.Name("tapLineButton"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(popStationDetailVC(_:)),
                                               name: NSNotification.Name("tapPopButton"),
                                               object: nil)
    }
    
//    private func presentStationDetailViewController(stationCode: Int) {
//        let stationDetailVc = StationDetailView(stationCode: stationCode)
//        stationDetailVc.modalPresentationStyle = .formSheet
//        stationDetailVc.sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
//        self.present(stationDetailVc, animated: true, completion: nil)
//    }
    
    private func presentStationDetailViewController(stationCode: Int) {
        self.stationDetailViewController = StationDetailViewController(stationCode: stationCode)
        stationDetailViewController?.modalPresentationStyle = .formSheet
        stationDetailViewController?.sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
        self.present(stationDetailViewController ?? UIViewController(), animated: false, completion: nil)
    }
    
    @objc private func tapStationButton(_ notification: Notification) {
        guard let stationCode = notification.object as? Int else { return }
        self.presentStationDetailViewController(stationCode: stationCode)
    }
    
    @objc private func tapLineButton(_ notification: Notification) {
        guard let stationCode = notification.object as? Int else { return }
        
        self.stationDetailViewController?.dismiss(animated: false)
        self.presentStationDetailViewController(stationCode: stationCode)
    }
    
    @objc private func popStationDetailVC(_ notification: Notification) {
        self.stationDetailViewController?.dismiss(animated: true)
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
