//
//  StepIngredientEntity.swift
//  Reciplease
//
//  Created by Mac Hack on 18/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import Foundation
import CoreData

class StepIngredientEntity: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [StepIngredientEntity] {
        let request: NSFetchRequest<StepIngredientEntity> = StepIngredientEntity.fetchRequest()
        
        guard let stepIngredient = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return stepIngredient
    }
}
