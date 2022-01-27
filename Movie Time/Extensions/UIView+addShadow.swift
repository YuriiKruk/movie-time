//
//  UIView+addShadow.swift
//  Movie Time
//
//  Created by Yury Kruk on 27.01.2022.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}
