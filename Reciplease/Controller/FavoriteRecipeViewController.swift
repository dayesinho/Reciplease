//
//  FavoriteRecipeViewController.swift
//  Reciplease
//
//  Created by Mac Hack on 10/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRecipeViewController: UIViewController {
    
    var favoritesRecipes = RecipeEntity.fetchAll()
    var stepIngredientsArray = [String]()
    var index = 0
    
    var favoriteBarButton: UIBarButtonItem?
    var favoriteIsOn : Bool = true
    let favoriteBorderImage = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
    let favoriteFullImage = UIImage(named: "YellowStar")
    
    @IBOutlet weak var favoriteRecipeTableView: UITableView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleRecipe: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetailsFavoriteRecipe()
        createFavoriteButton(favoriteStar: detectFavoriteRecipe())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteRecipeTableView.reloadData()
    }
    
    @objc public func favoriteButtonTapped(_ sender: UIButton) {
        
        createAnimationFavoriteButton()
        guard let favoriteRecipeID = favoritesRecipes[index].id else { return }
        RecipeEntity.deleteRecipe(favoriteRecipeID)
        createFavoriteButton(favoriteStar: detectFavoriteRecipe())
        _ = navigationController?.popViewController(animated: true)
    }
    
    func deactivateButton() {
        createFavoriteButton(favoriteStar: favoriteBorderImage!)
        guard let favoriteRecipeID = favoritesRecipes[index].id else { return }
        RecipeEntity.deleteRecipe(favoriteRecipeID)
    }
    
    private func detectFavoriteRecipe() -> UIImage {
        
        let favoriteRecipeID = favoritesRecipes[index].id
        
        if RecipeEntity.isRegistered(favoriteRecipeID ?? "") == true {
            return favoriteFullImage!
        } else {
            return favoriteBorderImage!
        }
    }
    
    @IBAction func getDirectionsButton(_ sender: UIButton) {
        guard let urlForSafari = favoritesRecipes[index].urlForSafari else { return }
        guard let url = URL(string: urlForSafari) else { return }
        UIApplication.shared.open(url)
    }
    
    func displayDetailsFavoriteRecipe() {
        
        guard let dataImage = favoritesRecipes[index].imageRecipe else { return }
        recipeImage.image = UIImage(data: dataImage)
        ratingLabel.text = favoritesRecipes[index].rating
        timeLabel.text = favoritesRecipes[index].time
        titleRecipe.text = favoritesRecipes[index].title
        addGradientBig(imageView: recipeImage)
        let stepIngredients = favoritesRecipes[index].stepIngredientEntities?.allObjects as? [StepIngredientEntity]
        stepIngredientsArray = stepIngredients?.map({ $0.stepIngredient }) as? [String] ?? []
        
    }
}

extension FavoriteRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepIngredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepIngredients", for: indexPath)
        cell.textLabel?.text = stepIngredientsArray[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
}
