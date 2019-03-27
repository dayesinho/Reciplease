//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Mac Hack on 22/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    /**
     * MARK: - Vars:
     */
    
    let yummlyService = YummlyService()
    var recipes : SearchRecipes?
    var ingredientArray = [String]()
    
    /**
     * MARK: - ViewDidLoad:
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTextField.delegate = self
        disableSearchButton()
        setEditButton()
    }
    
    /**
     * MARK: - OUTLETS:
     */
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
/**
* MARK: - ACTIONS:
*/
    
    /**
     *  Action to add a new ingredient into an array. It also detects if the user insert special characters of if the text field is empty:
     */
    
    @IBAction private func addIngredientButton(_ sender: UIButton) {
        mediumVibration()
        guard let ingredientAdded = ingredientsTextField.text.nilIfEmpty else {
            errorVibration()
            showAlert(title: "Something went wrong...", message: "Write your ingredient first, before to click 'Add'")
            return
        }
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        if ingredientAdded.rangeOfCharacter(from: characterset.inverted) != nil {
            errorVibration()
            showAlert(title: "Something went wrong...", message: "Sorry, the application doesn't handle with special characters")
            ingredientsTextField.text = ""
        } else {
            ingredientArray.append(ingredientAdded.firstUppercased)
            ingredientsTextField.text = ""
            disableSearchButton()
            setEditButton()
            ingredientTableView.reloadData()
        }
    }
    
    /**
     * Action to manage the behavior of the edit button and allow the users edit the cells:
     */
    
    @IBAction private func editButton(_ sender: UIButton) {
        mediumVibration()
        setEditButton()
        
        ingredientTableView.isEditing = !ingredientTableView.isEditing
        switch ingredientTableView.isEditing {
        case true:
            editButton.setTitle("Done", for: UIControl.State.normal)
        case false:
            editButton.setTitle("Edit", for: UIControl.State.normal)
        }
    }
    
    /**
     * Action to erase all the ingredients present in the array:
     */
    
    @IBAction private func eraseIngredients(_ sender: UIButton) {
        mediumVibration()
        ingredientArray.removeAll()
        disableSearchButton()
        setEditButton()
        ingredientTableView.reloadData()
    }
    
    /**
     * Action to make the API call and collect the datas of the recipes:
     */
    
    @IBAction private func searchRecipes(_ sender: UIButton) {
        mediumVibration()
        toggleActivityIndicator(searchButton: searchButton, activityIndicator: activityIndicator, shown: true)
        yummlyService.searchRecipes(params: ingredientArray) { success, recipes in
            self.toggleActivityIndicator(searchButton: self.searchButton, activityIndicator: self.activityIndicator, shown: false)
            if success, let recipes = recipes, recipes.matches.count > 0 {
                self.recipes = recipes
                self.performSegue(withIdentifier: "Results", sender: self)
            } else {
                self.errorVibration()

                self.showAlert(title: "Something went wrong...", message: "We weren't able to find a recipe with your ingredients. Please, check the name of your ingredients in the list.")
            }
        }
    }
    
    /**
     * Method to set up the edit button:
     */
    
    fileprivate func setEditButton() {
        if ingredientArray.isEmpty  {
            editButton.isEnabled = false
            editButton.setTitle("Edit", for: UIControl.State.normal)
            editButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        } else {
            editButton.isEnabled = true
            editButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }
    }
    
    /**
     * Segue to transfer the datas to the next controller:
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as? ResultsViewController
        resultViewController?.recipes = recipes
    }
    
    /**
     * Method to disable/enable the Search button and avoid empty requests:
     */
    
    private func disableSearchButton() {
        if ingredientArray.isEmpty {
            searchButton.isEnabled = false
            searchButton.backgroundColor = UIColor.darkGray
            searchButton.setTitleColor(UIColor.black, for: .disabled)
        } else {
            searchButton.isEnabled = true
            searchButton.backgroundColor = UIColor(red: 62/255.0, green: 137/255.0, blue: 85/255.0, alpha: 1)
        }
    }
    
    /**
     * Method to resign the first responder:
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

/**
 * Extensions for the TableViewDataSource and the TableViewDelegate to manage and provide datas on the TableView:
 */

extension SearchViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = "- " + ingredientArray[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Your list is actually empty"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ingredientArray.isEmpty ? 200 : 0
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
