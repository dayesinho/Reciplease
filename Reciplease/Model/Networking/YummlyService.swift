//
//  Network.swift
//  Reciplease
//
//  Created by Mac Hack on 22/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import Foundation
import Alamofire

class YummlyService {
    
    private var yummlySession: YummlySession
    
    init(yummlySession : YummlySession = YummlySession()) {
        self.yummlySession = yummlySession
    }
    
// Method to convert the array in String:
    
    func getIngredientsSeparated(ingredientArray: [String]) -> String {
        
        let ingredientsSeparated = ingredientArray.map({ $0.lowercased() }).joined(separator: "&allowedIngredient[]=").replacingOccurrences(of: " ", with: "")
        return "&q=&allowedIngredient[]=" + ingredientsSeparated
    }
    
// API call to search the recipes:
    
    func searchRecipes(params: [String], completionHandler: @escaping (Bool, SearchRecipes?) -> Void) {
        
        guard let url = URL(string: yummlySession.urlSearchAPI + yummlySession.appID + yummlySession.appKey + getIngredientsSeparated(ingredientArray: params)) else {return}
        
        yummlySession.request(url: url) { responseData in
            guard responseData.response?.statusCode == 200 else {
                completionHandler(false, nil)
                return
            }
            guard let data = responseData.data else {
                completionHandler(false, nil)
                return
            }
            guard let recipes = try? JSONDecoder().decode(SearchRecipes?.self, from: data) else {
                completionHandler(false, nil)
                return
            }
            completionHandler(true, recipes)
        }
    }
    
// API call to get the details of the recipe:
    
    func getRecipes(id: String, completionHandler: @escaping (Bool, GetRecipe?) -> Void) {
        
        guard let url = URL(string: yummlySession.urlGetAPI + id + yummlySession.appID + yummlySession.appKey) else { return }
        
        yummlySession.request(url: url) { (responseData) in
            guard responseData.response?.statusCode == 200 else {
                completionHandler(false, nil)
                return
            }
            guard let data = responseData.data else {
                completionHandler(false, nil)
                return
            }
            guard let recipes = try? JSONDecoder().decode(GetRecipe?.self, from: data) else {
                completionHandler(false, nil)
                return
            }
            completionHandler(true, recipes)
        }
    }
}

