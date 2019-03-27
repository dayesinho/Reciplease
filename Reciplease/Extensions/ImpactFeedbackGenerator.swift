//
//  Vibration.swift
//  Reciplease
//
//  Created by Mac Hack on 08/03/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func mediumVibration() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func successVibration() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func errorVibration() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
