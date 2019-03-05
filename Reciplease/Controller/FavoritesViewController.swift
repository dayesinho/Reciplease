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
    
    var favoritesRecipes = RecipeEntity.fetchAll()
    let searchController = UISearchController(searchResultsController: nil)
    var index = Int()
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesRecipes = RecipeEntity.fetchAll()
        favoritesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesRecipes = RecipeEntity.fetchAll()
    }
    
    func createSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor(red: 53/255.0, green: 49/255.0, blue: 48/255.0, alpha: 1)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search inside your favorite recipes"
        self.favoritesTableView.tableHeaderView = searchController.searchBar
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recipes = favoritesRecipes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoritesTableViewCell
        
        cell.recipeData = recipes
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        index = indexPath.row
        performSegue(withIdentifier: "FavoriteRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let favoriteRecipeViewController = segue.destination as? FavoriteRecipeViewController
        favoriteRecipeViewController?.index = index
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "You have no favorites..."
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return favoritesRecipes.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AppDelegate.viewContext.delete(favoritesRecipes[indexPath.row])
            favoritesRecipes.remove(at: indexPath.row)
            try? AppDelegate.viewContext.save()
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
}

////// BONUS ////////

extension FavoritesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarInput = searchController.searchBar.text else { return }
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBarInput)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            favoritesRecipes = try AppDelegate.viewContext.fetch(request)
        } catch let error as NSError {
            print("Error fetching data from context \(error)")
        }
        favoritesTableView.reloadData()
    }
}
