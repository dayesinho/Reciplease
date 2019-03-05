//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Mac Hack on 22/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let yummlyService = YummlyService()
    var recipes : SearchRecipes?
    var ingredientArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableSearchButton()
    }
    
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var searchForRecipes: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func addIngredientButton(_ sender: UIButton) {
        
        guard let ingredientAdded = ingredientsTextField.text?.firstUppercased else { return }
        
        if ingredientAdded.isEmpty {
            showAlert(title: "Oops", message: "Write your ingredient first, before to click 'Add'")
        } else {
            ingredientArray.append(ingredientAdded)
            ingredientsTextField.text = ""
            disableSearchButton()
            ingredientTableView.reloadData()
        }
    }
    
    @IBAction func eraseIngredients(_ sender: UIButton) {
        ingredientArray.removeAll()
        disableSearchButton()
        ingredientTableView.reloadData()
    }
    
    @IBAction func searchRecipes(_ sender: UIButton) {
        
        toggleActivityIndicator(searchButton: searchForRecipes, activityIndicator: activityIndicator, shown: true)
        yummlyService.searchRecipes(params: ingredientArray) { success, recipes in
            self.toggleActivityIndicator(searchButton: self.searchForRecipes, activityIndicator: self.activityIndicator, shown: false)
            if success, let recipes = recipes {
                self.recipes = recipes
                self.performSegue(withIdentifier: "Results", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as? ResultsViewController
        resultViewController?.recipes = recipes
    }
    
    func disableSearchButton() {
        if ingredientArray.isEmpty {
            searchForRecipes.isEnabled = false
            searchForRecipes.backgroundColor = UIColor.darkGray
            searchForRecipes.setTitleColor(UIColor.black, for: .disabled)
        } else {
            searchForRecipes.isEnabled = true
            searchForRecipes.backgroundColor = UIColor(red: 62/255.0, green: 137/255.0, blue: 85/255.0, alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = "- " + ingredientArray[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Your list is empty for the moment"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ingredientArray.isEmpty ? 200 : 0
    }
}
