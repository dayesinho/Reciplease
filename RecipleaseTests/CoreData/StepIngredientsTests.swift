//
//  StepIngredientsTests.swift
//  RecipleaseTests
//
//  Created by Mac Hack on 25/03/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class StepIngredientsTests: XCTestCase {

    lazy var mockContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (description, error) in
            XCTAssertNil(error)
        })
        return container
    }()
    
    func testInsertIngredientEntityInPersistentContainer() {
        for _ in 0 ..< 1000 {
            let stepIngredient = StepIngredientEntity(context: mockContainer.viewContext)
            stepIngredient.stepIngredient = "Test"
        }
        XCTAssertNoThrow(try mockContainer.newBackgroundContext().save())
    }
    
    func testFetchStepIngredientsEntity() {
        let stepIngredient = StepIngredientEntity(context: mockContainer.viewContext)
        stepIngredient.stepIngredient = "Test"
        try? mockContainer.viewContext.save()
        
        let request: NSFetchRequest<StepIngredientEntity> = StepIngredientEntity.fetchRequest()
        guard let stepIngredients = try? mockContainer.viewContext.fetch(request) else { return }
        XCTAssertFalse(stepIngredients.isEmpty)
    }
}
