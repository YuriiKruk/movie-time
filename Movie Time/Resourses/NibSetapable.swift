//
//  NibSetapable.swift
//  Movie Time
//
//  Created by Yury Kruk on 23.01.2022.
//

import UIKit

protocol NibSetapable: AnyObject {
    static var identifier: String { get }
    static func nib() -> UINib
}

extension NibSetapable {
    /// Returns cell identifier for class
    /// - Cell class must to have the same name like cell identifier
    static var identifier: String {
        String(describing: self)
    }
    
    /// Returns a UINib for cell class
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
