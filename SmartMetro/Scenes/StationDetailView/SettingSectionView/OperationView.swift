//
//  OperationView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/02/05.
//

import UIKit
import SnapKit
import SwiftUI

final class OperationView: UIView {
    private lazy var congestionButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("혼잡도", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .medium)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(tapCongestionButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var dataReloadButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "arrow.triangle.2.circlepath")
        
        return button
    }()
        
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "xmark")
        button.addTarget(self, action: #selector(tapDismissButton(_:)), for: .touchUpInside)
        
        return button
    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapCongestionButton(_ sender: UIButton) {
    }
    
    @objc private func tapDismissButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("tapDismissButtonOrImageView"),
                                        object: nil)
    }
}

private extension OperationView {
    func setUp() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [congestionButton, dataReloadButton, dismissButton].forEach { stackView.addArrangedSubview($0) }
    }
}

struct OperationView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            OperationView()
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
        
        typealias UIViewType = UIView
    }
}


