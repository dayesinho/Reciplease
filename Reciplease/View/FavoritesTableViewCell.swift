//
//  FavoritesTableViewCell.swift
//  Reciplease
//
//  Created by Mac Hack on 09/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsListLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeRecipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var recipeData : RecipeEntity! {
        didSet {
            titleRecipeLabel.text = recipeData.title
            timeRecipeLabel.text = recipeData.time
            ratingLabel.text = recipeData.rating
            guard let dataImage = recipeData.imageRecipe else { return }
            recipeImage.image = UIImage(data: dataImage)
            addGradientSmall(imageView: recipeImage)
            let ingredients = recipeData.ingredientEntities?.allObjects as? [IngredientEntity]
            let ingredientsMapped = ingredients?.map({ $0.ingredient ?? ""}).joined(separator: ",")
            ingredientsListLabel.text = ingredientsMapped
        }
    }
}
