//
//  ReceiptViewController.swift
//  Reciplease
//
//  Created by Mac Hack on 22/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    
    var favoritesRecipes = RecipeEntity.fetchAll()
    var detailRecipes : GetRecipe?
    var ingredientList = [String]()
    var stepIngredients = [String]()
    
    var favoriteBarButton: UIBarButtonItem?
    var favoriteIsOn = Bool()
    var favoriteBorderImage = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
    var favoriteFullImage = UIImage(named: "YellowStar")?.withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsForRecipe()
        createFavoriteButton(favoriteStar: detectFavoriteRecipe())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createFavoriteButton(favoriteStar: detectFavoriteRecipe())
        recipeTableView.reloadData()
    }
    
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var timeRecipe: UILabel!
    @IBOutlet weak var titleRecipe: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func getDirectionsButton(_ sender: UIButton) {
        guard let detailRecipes = detailRecipes else { return }
        guard let url = URL(string: detailRecipes.source.sourceRecipeURL) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        guard let detailRecipes = detailRecipes else { return }
        
        if RecipeEntity.isRegistered(detailRecipes.id) == false {
            createAnimationFavoriteButton()
            saveRecipeDetails()
            favoriteIsOn = true
        } else {
            createAnimationFavoriteButton()
            RecipeEntity.deleteRecipe(detailRecipes.id)
            favoriteIsOn = false
            createFavoriteButton(favoriteStar: detectFavoriteRecipe())
        }
    }
    
    // Show results on the UI:
    
    private func detailsForRecipe() {
        
        guard let detailRecipes = detailRecipes else { return }
        guard let imageURL = URL(string: detailRecipes.images[0].hostedLargeURL) else { return }
        guard let recipeImage = try? Data(contentsOf: imageURL) else { return }
        recipeImageView.image = UIImage(data: recipeImage)
        addGradientBig(imageView: recipeImageView)
        stepIngredients = detailRecipes.ingredientLines
        titleRecipe.text = detailRecipes.name
        timeRecipe.text = detailRecipes.totalTime
        rating.text = String(detailRecipes.rating)
    }
    
    // CoreData saving datas:
    
    func saveRecipeDetails() {
        
        guard let detailRecipes = detailRecipes else { return }
        guard let imageURL = URL(string: (detailRecipes.images[0].hostedLargeURL).updateSizeOfUrlImageString) else { return }
        let recipeContext = RecipeEntity(context: AppDelegate.viewContext)
        let recipeImage = try? Data(contentsOf: imageURL)
        recipeContext.title = detailRecipes.name
        recipeContext.time = detailRecipes.totalTime
        recipeContext.rating = String(detailRecipes.rating)
        recipeContext.urlForSafari = detailRecipes.source.sourceRecipeURL
        recipeContext.imageRecipe = recipeImage
        recipeContext.id = detailRecipes.id
        saveIngredient(recipeEntity: recipeContext)
        saveStepIngredient(recipeEntity: recipeContext)
        try? AppDelegate.viewContext.save()
    }
    
    func saveIngredient(recipeEntity: RecipeEntity) {
        for ingredient in ingredientList {
            let ingredientContext = IngredientEntity(context: AppDelegate.viewContext)
            ingredientContext.ingredient = ingredient
            ingredientContext.recipe = recipeEntity
        }
    }
    
    func saveStepIngredient(recipeEntity: RecipeEntity) {
        for stepIngredient in stepIngredients {
            let stepIngredientContext = StepIngredientEntity(context: AppDelegate.viewContext)
            stepIngredientContext.stepIngredient = stepIngredient
            stepIngredientContext.recipe = recipeEntity
        }
    }
    
    func detectFavoriteRecipe() -> UIImage {
        
        guard let detailRecipes = detailRecipes else { return favoriteBorderImage!}
        if RecipeEntity.isRegistered(detailRecipes.id) == true {
            return favoriteFullImage!
        } else {
            return favoriteBorderImage!
        }
    }
}

// Extension for TableViewDataSource:

extension RecipeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stepIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
        cell.textLabel?.text = "- " + stepIngredients[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
}
