//
//  ResultTableViewCell.swift
//  Reciplease
//
//  Created by Mac Hack on 31/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
 
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeRecipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var recipeData: Match! {
        
        didSet {
            
            guard let imageURL = URL(string: recipeData.smallImageUrls[0].updateSizeOfUrlImageString) else { return }
            if let imageFromURL = try? Data(contentsOf: imageURL) {
                recipeImageView.image = UIImage(data: imageFromURL)
            } else {
                recipeImageView.image = UIImage(named: "NotAvailable")
            }
            addGradientSmall(imageView: recipeImageView)
            recipeTitleLabel.text = recipeData.recipeName
            let stringArray = recipeData.ingredients.map { $0 }
            ingredientsLabel.text = stringArray.joined(separator: ", ")
            ratingLabel.text = String(recipeData.rating) 
            guard let timeInSeconds = recipeData.totalTimeInSeconds else { return }
            timeRecipeLabel.text = String(formatTime(time: timeInSeconds))
        }
    }
    
    private func formatTime(time: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        
        guard let formattedString = formatter.string(from: TimeInterval(time)) else { return "" }
        return formattedString
    }
    
    private func addGradientSmall(imageView: UIImageView) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 200)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.7]
        imageView.layer.addSublayer(layer)
    }
}
