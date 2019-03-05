//
//  RecipesSteps.swift
//  Reciplease
//
//  Created by Mac Hack on 06/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import Foundation

struct GetRecipe: Decodable {
    let totalTime: String
    let images: [Image]
    let name: String
    let source: Source
    let id: String
    let ingredientLines: [String]
    let numberOfServings, totalTimeInSeconds: Int
    let rating: Int
}

struct Image: Decodable {
    let hostedLargeURL: String
    
    enum CodingKeys: String, CodingKey {
        case hostedLargeURL = "hostedLargeUrl"
    }
}

struct Source: Decodable {
    let sourceRecipeURL: String
    
    enum CodingKeys: String, CodingKey {
        case sourceRecipeURL = "sourceRecipeUrl"
    }
}
