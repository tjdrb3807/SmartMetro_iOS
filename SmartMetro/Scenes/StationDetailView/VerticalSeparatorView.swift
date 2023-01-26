//
//  VerticalSeparatorView.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/26.
//

import UIKit
import SnapKit

final class VerticalSeparatorView: UIView {
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .separator
        
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(1.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
