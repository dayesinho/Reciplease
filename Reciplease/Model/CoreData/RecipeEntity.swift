//
//  RecipeEntity.swift
//  Reciplease
//
//  Created by Mac Hack on 18/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit
import CoreData

class RecipeEntity: NSManagedObject {
    
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipes
    }
    
    static func deleteRecipe(_ id: String) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let recipe = try AppDelegate.viewContext.fetch(request)
            if recipe.isEmpty == false {
                AppDelegate.viewContext.delete(recipe[0])
                try? AppDelegate.viewContext.save()
            }
        } catch let error as NSError {
            print("Error fetching data from context \(error)")
        }
    }
    
    static func isRegistered(_ id: String) -> Bool {
        
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let recipe = try AppDelegate.viewContext.fetch(request)
            if recipe.isEmpty {
                return false
            }
        } catch let error as NSError {
            print("Error fetching data from context \(error)")
        }
        return true
    }
    
//    static func searchBar(with searchBarInput: String) -> [RecipeEntity] {
//        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBarInput)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        do {
//            guard let recipes = try? AppDelegate.viewContext.fetch(request) else { return [] }
//        }
//         return recipes
//    }
}

