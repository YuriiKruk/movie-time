//
//  HapticManager.swift
//  Movie Time
//
//  Created by Yury Kruk on 31.01.2022.
//

import Foundation
import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    func vibrateForImpactFeedback() {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator()
            generator.prepare()
            generator.impactOccurred()
            
        }
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
