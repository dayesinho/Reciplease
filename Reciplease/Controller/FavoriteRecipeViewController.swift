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
    
    /**
     * MARK: - Vars:
     */
    
    var favoritesRecipes = RecipeEntity.fetchAll()
    var stepIngredientsArray = [String]()
    var index = 0
    
    var favoriteBarButton: UIBarButtonItem?
    var favoriteIsOn : Bool = true
    let favoriteBorderImage = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
    let favoriteFullImage = UIImage(named: "YellowStar")
  
    /**
     * MARK: - OUTLETS:
     */
    
    @IBOutlet weak var favoriteRecipeTableView: UITableView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleRecipe: UILabel!
    
    /**
     * MARK: - ViewDidLoad:
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetailsFavoriteRecipe()
        createFavoriteButton(favoriteStar: detectFavoriteRecipe())
    }
    
    /**
     * MARK: - ViewWillAppear:
     */
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteRecipeTableView.reloadData()
    }
    
    /**
     * MARK: - ACTION: Action to manage the state of the favorite icon and removing the recipe choosen from Core Data:
     */
    
    @objc internal func favoriteButtonTapped(_ sender: UIButton) {
        successVibration()
        createAnimationFavoriteButton()
        guard let favoriteRecipeID = favoritesRecipes[index].id else { return }
        RecipeEntity.deleteRecipe(favoriteRecipeID)
        createFavoriteButton(favoriteStar: detectFavoriteRecipe())
        _ = navigationController?.popViewController(animated: true)
    }
    
    /**
     *Action in which we provide the URL to open the recipe into Safari Browser:
     */
    
    @IBAction private func getDirectionsButton(_ sender: UIButton) {
        mediumVibration()
        guard let urlForSafari = favoritesRecipes[index].urlForSafari else { return }
        guard let url = URL(string: urlForSafari) else { return }
        UIApplication.shared.open(url)
    }
    
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
     * Method allowing the suppression of the recipe on Core Data:
     */
    
    private func deactivateButton() {
        createFavoriteButton(favoriteStar: favoriteBorderImage ?? UIImage())
        guard let favoriteRecipeID = favoritesRecipes[index].id else { return }
        RecipeEntity.deleteRecipe(favoriteRecipeID)
    }
    
    /**
     * Method to detect if the recipe is present into Core Data and makes returning the adequate UIImage:
     */
    
    private func detectFavoriteRecipe() -> UIImage {
        
        let favoriteRecipeID = favoritesRecipes[index].id
        
        if RecipeEntity.isRegistered(favoriteRecipeID ?? "") == true {
            return favoriteFullImage ?? UIImage()
        } else {
            return favoriteBorderImage ?? UIImage()
        }
    }
    
    /**
     * Method to show the recipe choosen in the UI for the user:
     */
    
    private func displayDetailsFavoriteRecipe() {
        
        guard let dataImage = favoritesRecipes[index].imageRecipe else { return }
        recipeImage.image = UIImage(data: dataImage)
        ratingLabel.text = favoritesRecipes[index].rating
        timeLabel.text = favoritesRecipes[index].time
        titleRecipe.text = favoritesRecipes[index].title
        addGradientBig(imageView: recipeImage)
        let stepIngredients = favoritesRecipes[index].stepIngredientEntities?.allObjects as? [StepIngredientEntity]
        stepIngredientsArray = stepIngredients?.map({ $0.stepIngredient }) as? [String] ?? []
        
    }
    
    private func addGradientBig(imageView: UIImageView) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 240)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.7]
        imageView.layer.addSublayer(layer)
    }
}

/**
 * Extensions for the TableViewDataSource to provide datas on the TableView:
 */

extension FavoriteRecipeViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepIngredientsArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepIngredients", for: indexPath)
        cell.textLabel?.text = stepIngredientsArray[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
}
