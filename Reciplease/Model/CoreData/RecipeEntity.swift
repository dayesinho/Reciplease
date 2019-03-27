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
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return recipes
    }
    
    static func deleteRecipe(_ id: String, viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let recipes = try? viewContext.fetch(request) else { return }
        guard let recipe = recipes.first else { return }
        viewContext.delete(recipe)
        try? viewContext.save()
    }
    
    static func isRegistered(_ id: String, viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> Bool {
        
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let recipe = try? viewContext.fetch(request)
        if recipe?.isEmpty ?? false { return false }
        return true
    }
    
    static func fetchByName(with searchBarInput: String, viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBarInput)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        guard let recipes = try? viewContext.fetch(request) else { return [] }
        return recipes
    }
}

