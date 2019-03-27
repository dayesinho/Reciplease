//
//  ResultViewController.swift
//  Reciplease
//
//  Created by Mac Hack on 22/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    /**
     * MARK: - Vars:
     */
    
    let yummlyService = YummlyService()
    var recipes : SearchRecipes?
    var detailRecipes : GetRecipe?
    var recipeIngredients = [String]()
    
    /**
     * MARK: - ViewDidLoad:
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.reloadData()
    }
    
    /**
     * MARK: - ViewDidAppear:
     */
    
    override func viewDidAppear(_ animated: Bool) {
        resultTableView.isUserInteractionEnabled = true
    }
    
    /**
     * MARK: - OUTLETS:
     */
    @IBOutlet weak var resultTableView: UITableView!
    
    /**
     * Segue to transfer the datas to the next controller:
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipeViewController = segue.destination as? RecipeViewController
        recipeViewController?.detailRecipes = detailRecipes
        recipeViewController?.ingredientList = recipeIngredients
    }
}

/**
 * Extensions for the TableViewDataSource and the TableViewDelegate to manage and provide datas on the TableView:
 */

extension ResultsViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipesResults = recipes else { return 0 }
        return recipesResults.matches.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recipe = recipes?.matches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! ResultTableViewCell
        cell.selectionStyle = .none
        cell.recipeData = recipe
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mediumVibration()
        resultTableView.isUserInteractionEnabled = false
        
        guard let recipeID = recipes?.matches[indexPath.row].id else { return }
        guard let ingredientsList = recipes?.matches[indexPath.row].ingredients else { return }
        
        yummlyService.getRecipes(id: recipeID + "?") { success, detailRecipes in
            if success, let detailRecipes = detailRecipes {
                self.detailRecipes = detailRecipes
                self.recipeIngredients = ingredientsList
                self.performSegue(withIdentifier: "DetailRecipe", sender: self)
            }
        }
    }
}

extension ResultsViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
