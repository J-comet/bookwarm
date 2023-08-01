//
//  Extension.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/01.
//

import UIKit

extension UIColor {
    static var randomColor: UIColor {
        return UIColor(red:CGFloat.random(in: 50..<255)/255.0, green:CGFloat.random(in: 50..<255)/255.0, blue:CGFloat.random(in: 50..<255)/255.0, alpha:1.0)
    }
}
