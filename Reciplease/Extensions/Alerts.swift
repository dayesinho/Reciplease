//
//  Alerts.swift
//  Reciplease
//
//  Created by Mac Hack on 02/03/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
}
