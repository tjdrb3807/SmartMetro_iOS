//
//  CurrentStationNameLabel.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/28.
//

import UIKit

class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
