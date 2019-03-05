//
//  UIImageView.swift
//  Reciplease
//
//  Created by Mac Hack on 02/03/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addGradientSmall(imageView: UIImageView) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.7]
        imageView.layer.addSublayer(layer)
    }
    
    func addGradientBig(imageView: UIImageView) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500, height: 240)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.6]
        imageView.layer.addSublayer(layer)
    }
}

extension UITableViewCell {
    
    func addGradientSmall(imageView: UIImageView) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.7]
        imageView.layer.addSublayer(layer)
    }
    
    func addGradientBig(imageView: UIImageView) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500, height: 240)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.6]
        imageView.layer.addSublayer(layer)
    }
}
