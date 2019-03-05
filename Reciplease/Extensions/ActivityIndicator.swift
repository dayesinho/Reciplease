//
//  ActivityIndicator.swift
//  Reciplease
//
//  Created by Mac Hack on 04/03/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func toggleActivityIndicator(searchButton: UIButton, activityIndicator: UIActivityIndicatorView, shown: Bool) {
        searchButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}
