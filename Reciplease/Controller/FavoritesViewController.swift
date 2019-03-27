//
//  FavoritesViewController.swift
//  Reciplease
//
//  Created by Mac Hack on 08/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    /**
     * MARK: - Vars:
     */
    
    var favoritesRecipes = RecipeEntity.fetchAll()
    let searchController = UISearchController(searchResultsController: nil)
    var index = Int()
    
    /**
     * MARK: - OUTLETS:
     */
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    /**
     * MARK: - ViewDidLoad:
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchController()
    }
    
    /**
     * MARK: - ViewWillAppear:
     */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesRecipes = RecipeEntity.fetchAll()
        favoritesTableView.reloadData()
    }
    
    /**
     * MARK: - ViewDidAppear:
     */
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesRecipes = RecipeEntity.fetchAll()
    }
    
    /**
     * Method to create a search controller on the UI, above the navigation bar title:
     */
    
    private func createSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search inside your favorite recipes"
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
}

/**
 * Extensions for the TableViewDataSource and the TableViewDelegate to manage and provide datas on the TableView:
 */

extension FavoritesViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesRecipes.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recipes = favoritesRecipes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoritesTableViewCell
        
        cell.recipeData = recipes
        cell.selectionStyle = .none
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mediumVibration()
        index = indexPath.row
        performSegue(withIdentifier: "FavoriteRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let favoriteRecipeViewController = segue.destination as? FavoriteRecipeViewController
        favoriteRecipeViewController?.index = index
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "You have no favorites in your list."
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return favoritesRecipes.isEmpty ? 200 : 0
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AppDelegate.viewContext.delete(favoritesRecipes[indexPath.row])
            favoritesRecipes.remove(at: indexPath.row)
            try? AppDelegate.viewContext.save()
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
}

////// BONUS ////////

/**
 * Extention of the UISearchResultsUpdating that permits the user search inside is own favorites recipes (wit the elements present in the title:
 */

extension FavoritesViewController: UISearchResultsUpdating {
    
    private func didTextChanged(searchInput: String) {
        if searchInput == "" {
            favoritesRecipes = RecipeEntity.fetchAll()
            favoritesTableView.reloadData()
        } else {
            favoritesRecipes = RecipeEntity.fetchByName(with: searchInput)
            favoritesTableView.reloadData()
        }
    }
    
    internal func updateSearchResults(for searchController: UISearchController) {
        guard let searchInput = searchController.searchBar.text else { return }
        didTextChanged(searchInput: searchInput)
    }
}
