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
    
    /**
     * MARK: - Vars:
     */
    
    var favoritesRecipes = RecipeEntity.fetchAll()
    var detailRecipes : GetRecipe?
    var ingredientList = [String]()
    var stepIngredients = [String]()
    var favoriteBarButton: UIBarButtonItem?
    var favoriteIsOn = Bool()
    var favoriteBorderImage = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
    var favoriteFullImage = UIImage(named: "YellowStar")?.withRenderingMode(.alwaysTemplate)
    
    /**
     * MARK: - ViewDidLoad:
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsForRecipe()
        createFavoriteButton(favoriteStar: detectFavoriteRecipe())
    }
    
    /**
     * MARK: - ViewDidAppear:
     */
    
    override func viewDidAppear(_ animated: Bool) {
        createFavoriteButton(favoriteStar: detectFavoriteRecipe())
        recipeTableView.reloadData()
    }
    
    /**
     * MARK: - OUTLETS:
     */
    
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var timeRecipe: UILabel!
    @IBOutlet weak var titleRecipe: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /**
     * Action in which we provide the URL to open the recipe into Safari Browser:
     */
    
    @IBAction private func getDirectionsButton(_ sender: UIButton) {
        mediumVibration()
        guard let detailRecipes = detailRecipes else { return }
        guard let url = URL(string: detailRecipes.source.sourceRecipeURL) else { return }
        UIApplication.shared.open(url)
    }
    
    /**
     * Action to manage the behavior of the Favorite icon, detecting the recipes present in Core Data:
     */
    
    @objc internal func favoriteButtonTapped(_ sender: UIButton) {
        successVibration()
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

/**
* METHODS:
*/
    
    /**
     * Method to create the favorite icon on the UI:
     */
    
    func createFavoriteButton(favoriteStar: UIImage) {
        let favoriteButton = UIButton(type: .system)
        favoriteButton.tintColor = .yellow
        favoriteButton.setImage(favoriteStar, for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        self.favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.setRightBarButton(favoriteBarButton, animated: false)
    }
    
    /**
     * Method to create an animation when the favorite icon is pressed:
     */
    
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
    
    /**
     * Method to show the recipe choosen in the UI for the user:
     */
    
    private func detailsForRecipe() {
        
        guard let detailRecipes = detailRecipes else { return }
        guard let imageURL = URL(string: detailRecipes.images[0].hostedLargeURL) else { return }
        if let recipeImage = try? Data(contentsOf: imageURL) {
            recipeImageView.image = UIImage(data: recipeImage)
        } else {
            recipeImageView.image = UIImage(named: "NotAvailable")
        }
        addGradientBig(imageView: recipeImageView)
        stepIngredients = detailRecipes.ingredientLines
        titleRecipe.text = detailRecipes.name
        timeRecipe.text = detailRecipes.totalTime
        rating.text = String(detailRecipes.rating)
    }
    
    func addGradientBig(imageView: UIImageView) {
     
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 240)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.7]
        imageView.layer.addSublayer(layer)
    }
    
    /**
     * Method to save the details of the recipe into Core Data:
     */
    
    private func saveRecipeDetails() {
        
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
    
    private func saveIngredient(recipeEntity: RecipeEntity) {
        for ingredient in ingredientList {
            let ingredientContext = IngredientEntity(context: AppDelegate.viewContext)
            ingredientContext.ingredient = ingredient
            ingredientContext.recipe = recipeEntity
        }
    }
    
    private func saveStepIngredient(recipeEntity: RecipeEntity) {
        for stepIngredient in stepIngredients {
            let stepIngredientContext = StepIngredientEntity(context: AppDelegate.viewContext)
            stepIngredientContext.stepIngredient = stepIngredient
            stepIngredientContext.recipe = recipeEntity
        }
    }
    
    /**
     * Method to detect if the recipe is present into Core Data and makes returning the adequate UIImage:
     */
    
    private func detectFavoriteRecipe() -> UIImage {
        
        if RecipeEntity.isRegistered(detailRecipes?.id ?? "") == false {
            return favoriteBorderImage ?? UIImage()
        } else {
            return favoriteFullImage ?? UIImage()
        }
    }
}

/**
* Extensions for the TableViewDataSource to provide datas on the TableView:
*/

extension RecipeViewController : UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stepIngredients.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
        cell.textLabel?.text = "- " + stepIngredients[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
}
