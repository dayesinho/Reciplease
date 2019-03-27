//
//  CoredataWithMockContainerTests.swift
//  RecipleaseTests
//
//  Created by Mac Hack on 07/03/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class RecipeTests: XCTestCase {

//MARK: - Properties
    lazy var mockContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (description, error) in
            XCTAssertNil(error)
        })
        return container
    }()
  
//MARK: - Helper Methods
    
    private func insertRecipeEntity(into managedObjectContext: NSManagedObjectContext) {
        let newRecipeEntity = RecipeEntity(context: managedObjectContext)
        newRecipeEntity.id = "Test"
        newRecipeEntity.imageRecipe = Data(base64Encoded: "Test")
        newRecipeEntity.rating = "Test"
        newRecipeEntity.time = "Test"
        newRecipeEntity.title = "Test"
        newRecipeEntity.urlForSafari = "Test"
        let ingredient = IngredientEntity(context: managedObjectContext)
        ingredient.recipe = newRecipeEntity
        ingredient.ingredient = "Test"
        let stepIngredients = StepIngredientEntity(context: managedObjectContext)
        stepIngredients.recipe = newRecipeEntity
        stepIngredients.stepIngredient = "Test"
    }
  
//MARK: - Unit Tests:
    
    func testInsertRecipeEntityInPersistentContainer() {
        for _ in 0 ..< 100 {
            insertRecipeEntity(into: mockContainer.newBackgroundContext())
        }
        XCTAssertNoThrow(try mockContainer.newBackgroundContext().save())
    }
    
    func testGivenRecipeInCoreData_WhenRemoveThisRecipeWithID_ThenRecipeIsDeleteOnCoreData() {
        
        let newRecipeEntity = RecipeEntity(context: mockContainer.viewContext)
        newRecipeEntity.id = "Test"
        newRecipeEntity.imageRecipe = Data(base64Encoded: "Test")
        newRecipeEntity.rating = "Test"
        newRecipeEntity.time = "Test"
        newRecipeEntity.title = "Test"
        newRecipeEntity.urlForSafari = "Test"
        try? mockContainer.viewContext.save()
        
        RecipeEntity.deleteRecipe("Test", viewContext: mockContainer.viewContext)
        XCTAssertEqual(RecipeEntity.fetchAll(viewContext: mockContainer.viewContext), [])
    }
    
    func testGivenRecipeInCoreData_WhenCheckThisRecipeWithID_ThenRecipeIsRetrievedOnCoreData() {
        
        let newRecipeEntity = RecipeEntity(context: mockContainer.viewContext)
        newRecipeEntity.id = "Test"
        newRecipeEntity.imageRecipe = Data(base64Encoded: "Test")
        newRecipeEntity.rating = "Test"
        newRecipeEntity.time = "Test"
        newRecipeEntity.title = "Test"
        newRecipeEntity.urlForSafari = "Test"
        try? mockContainer.viewContext.save()
        
        XCTAssertTrue(RecipeEntity.isRegistered("Test", viewContext: mockContainer.viewContext))
    }
    
    func testGivenRecipeInCoreData_WhenCheckThisRecipeWithID_ThenRecipeIsNotRetrievedOnCoreData() {
        
        XCTAssertFalse(RecipeEntity.isRegistered("Test", viewContext: mockContainer.viewContext))
    }
    
    func testGivenRecipeInCoreData_WhenSearchThisRecipeWithID_ThenRecipeIsRetrievedOnCoreData() {
        
        let newRecipeEntity = RecipeEntity(context: mockContainer.viewContext)
        newRecipeEntity.id = "Test"
        newRecipeEntity.imageRecipe = Data(base64Encoded: "Test")
        newRecipeEntity.rating = "Test"
        newRecipeEntity.time = "Test"
        newRecipeEntity.title = "Test"
        newRecipeEntity.urlForSafari = "Test"
        try? mockContainer.viewContext.save()
       
        let favoriteRecipe = RecipeEntity.fetchByName(with: "Test", viewContext: mockContainer.viewContext)
        XCTAssertFalse(favoriteRecipe.isEmpty)
    }
}
