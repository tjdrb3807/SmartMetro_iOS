//
//  UIButton.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/20.
//

import UIKit

extension UIButton {
    func setImage(systemName: String) {
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .zero
        
        setImage(UIImage(systemName: systemName), for: .normal)
    }
}
