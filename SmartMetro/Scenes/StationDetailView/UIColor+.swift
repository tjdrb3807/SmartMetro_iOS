//
//  UIColor+.swift
//  SmartMetro
//
//  Created by 전성규 on 2023/01/26.
//

import UIKit

extension UIColor {
    //MARK: 호선 추가 필요
    static func setColor(lineNumber: Int) -> UIColor {
        switch lineNumber {
        case 1:
            return UIColor(red: 41/255, green: 60/255, blue: 249/222, alpha: 1.0)
        case 2:
            return UIColor(red: 96/255, green: 176/255, blue: 87/255, alpha: 1.0)
        case 3:
            return UIColor(red: 240/255, green: 123/255, blue: 48/255, alpha: 1.0)
        case 4:
            return UIColor(red: 82/255, green: 156/255, blue: 222/255, alpha: 1.0)
        case 5:
            return UIColor(red: 127/255, green: 49/255, blue: 226/255, alpha: 1.0)
        case 6:
            return UIColor(red: 164/255, green: 86/255, blue: 37/255, alpha: 1.0)
        case 7:
            return UIColor(red: 107/255, green: 114/255, blue: 40/255, alpha: 1.0)
        case 8:
            return UIColor(red: 215/255, green: 55/255, blue: 109/255, alpha: 1.0)
        case 9:
            return UIColor(red: 220/255, green: 164/255, blue: 74/255, alpha: 1.0)
        case 10: // 경의 중앙선
            return UIColor(red: 105/255, green: 157/255, blue: 122/255, alpha: 1.0)
        default:
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
    }
}
