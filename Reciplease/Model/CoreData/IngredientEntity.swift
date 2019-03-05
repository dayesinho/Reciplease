//
//  IngredientEntity.swift
//  Reciplease
//
//  Created by Mac Hack on 18/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import Foundation
import CoreData

class IngredientEntity: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [IngredientEntity] {
        let request: NSFetchRequest<IngredientEntity> = IngredientEntity.fetchRequest()
        guard let ingredient = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return ingredient
    }
}

