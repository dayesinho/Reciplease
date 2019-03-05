//
//  FavoriteRecipeVC.swift
//  Reciplease
//
//  Created by Mac Hack on 20/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

extension RecipeViewController  {
    
    func createFavoriteButton(favoriteStar: UIImage) {
        let favoriteButton = UIButton(type: .system)
        favoriteButton.tintColor = .yellow
        favoriteButton.setImage(favoriteStar, for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        self.favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.setRightBarButton(favoriteBarButton, animated: false)
    }
    
    func createAnimationFavoriteButton() {
        favoriteBarButton?.customView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 10,
                       options: .curveEaseInOut,
                       animations: {
                        self.favoriteIsOn = !self.favoriteIsOn
                        let image = self.favoriteIsOn ? self.favoriteFullImage : self.favoriteBorderImage
                        if let button = self.favoriteBarButton?.customView as? UIButton {
                            button.setImage(image, for: .normal)
                        }
                        self.favoriteBarButton?.customView?.transform = .identity
        }, completion: nil)
    }
}

extension FavoriteRecipeViewController {
    
    func createFavoriteButton(favoriteStar: UIImage) {
        let favoriteButton = UIButton(type: .system)
        favoriteButton.tintColor = .yellow
        favoriteButton.setImage(favoriteStar, for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        self.favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.setRightBarButton(favoriteBarButton, animated: false)
    }
    
    func createAnimationFavoriteButton() {
        favoriteBarButton?.customView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 10,
                       options: .curveEaseInOut,
                       animations: {
                        self.favoriteIsOn = !self.favoriteIsOn
                        let image = self.favoriteIsOn ? self.favoriteFullImage : self.favoriteBorderImage
                        if let button = self.favoriteBarButton?.customView as? UIButton {
                            button.setImage(image, for: .normal)
                        }
                        self.favoriteBarButton?.customView?.transform = .identity
        }, completion: nil)
    }
}
