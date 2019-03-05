//
//  CoreDataTests.swift
//  RecipleaseTests
//
//  Created by Mac Hack on 10/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class CoredataWithMockContainerTests: XCTestCase {
    
    lazy var mockContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeEntity")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (description, error) in
            XCTAssertNil(error)
        })
        return container
    }()
    
    //MARK: - Vars
    let viewContext: NSManagedObjectContext = AppDelegate.persistentContainer.newBackgroundContext()
    
    //MARK: - Tests Life Cycle
    override func tearDown() {
//        RecipeEntity.deleteRecipe("Homemade-Blue-Lemonade-2536078")(viewContext: mockContainer.viewContext)
        super.tearDown()
    }
    
    //MARK: - Helper Methods
  
    
    //MARK: - Unit Tests
//    func testInsertManyToDoItemsInPersistentContainer() {
//        for _ in 0 ..< 100000 {
//            insertFavoriteItem(into: viewContext)
//        }
//        XCTAssertNoThrow(try viewContext.save())
//    }
}
