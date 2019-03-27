//
//  Struct.swift
//  Reciplease
//
//  Created by Mac Hack on 30/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import Foundation

struct SearchRecipes: Decodable {
    let matches: [Match]
    let totalMatchCount: Int
}

struct Match: Decodable {
    let sourceDisplayName: String
    let ingredients: [String]
    let id: String
    let smallImageUrls: [String]
    let recipeName: String
    let totalTimeInSeconds: Int?
    let rating: Int
}



