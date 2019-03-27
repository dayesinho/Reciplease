//
//  YummlyServiceTests.swift
//  RecipleaseTests
//
//  Created by Mac Hack on 07/03/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import XCTest
@testable import Reciplease

class YummlyServiceTests: XCTestCase {
    
// Tests for searching recipes:
    
    func testSearchRecipesShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
        let searchSessionFake = SearchSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: searchSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.searchRecipes(params: ["lemon"]) { success, searchRecipes in
            XCTAssertFalse(success)
            XCTAssertNil(searchRecipes)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfNoData() {
        let fakeResponse = FakeResponse(response: nil, data: FakeResponseData.incorrectData, error: nil)
        let searchSessionFake = SearchSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: searchSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.searchRecipes(params: ["lemon"]) { success, searchRecipes in
            XCTAssertFalse(success)
            XCTAssertNil(searchRecipes)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.searchCorrectData, error: nil)
        let searchSessionFake = SearchSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: searchSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.searchRecipes(params: ["lemon"]) { success, searchRecipes in
            XCTAssertFalse(success)
            XCTAssertNil(searchRecipes)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfResponseCorrectAndNilData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, error: nil)
        let searchSessionFake = SearchSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: searchSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.searchRecipes(params: ["lemon"]) { success, searchRecipes in
            XCTAssertFalse(success)
            XCTAssertNil(searchRecipes)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let searchSessionFake = SearchSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: searchSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.searchRecipes(params: ["lemon"]) { success, searchRecipes in
            XCTAssertFalse(success)
            XCTAssertNil(searchRecipes)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.searchCorrectData, error: nil)
        let searchSessionFake = SearchSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: searchSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.searchRecipes(params: ["&q=&allowedIngredient[]=lemon"]) { success, searchRecipes in
            XCTAssertTrue(success)
            XCTAssertNotNil(searchRecipes)
            XCTAssertEqual(searchRecipes?.matches[0].id, "Baked-Seafood-Stuffed-Avocados-2676307")
            XCTAssertEqual(searchRecipes?.matches[0].rating, 4)
            XCTAssertEqual(searchRecipes?.matches[0].totalTimeInSeconds, 2100)
            XCTAssertEqual(searchRecipes?.matches[0].recipeName, "Baked Seafood Stuffed Avocados")
            XCTAssertEqual(searchRecipes?.matches[0].smallImageUrls[0], "https://lh3.googleusercontent.com/QbRqZocTvMKbGLD5DwERLWXuOzaC456D-SsAiGxVYqRdtpqTQ49VjOyZoHlcRljkySA4RBCeQOy5sseJq-dMig=s90")
            XCTAssertEqual(searchRecipes?.matches[0].ingredients, [
                "avocados",
                "cooked shrimp",
                "cooked crab",
                "cheddar",
                "vidalia onion",
                "eggs",
                "fresh parsley",
                "lemon juice",
                "seafood seasoning"
                ])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
// Tests to get a specified recipy:
    
    func testGetRecipeShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
        let getSessionFake = GetSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: getSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.getRecipes(id: "Baked-Seafood-Stuffed-Avocados-2676307") { success, getRecipe in
            XCTAssertFalse(success)
            XCTAssertNil(getRecipe)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfNoData() {
        let fakeResponse = FakeResponse(response: nil, data: FakeResponseData.incorrectData, error: nil)
        let getSessionFake = GetSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: getSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.getRecipes(id: "Baked-Seafood-Stuffed-Avocados-2676307"){ success, getRecipe in
            XCTAssertFalse(success)
            XCTAssertNil(getRecipe)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.getCorrectData, error: nil)
        let getSessionFake = GetSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: getSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.getRecipes(id: "Baked-Seafood-Stuffed-Avocados-2676307") { success, getRecipe in
            XCTAssertFalse(success)
            XCTAssertNil(getRecipe)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfResponseCorrectAndNilData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, error: nil)
        let getSessionFake = GetSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: getSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.getRecipes(id: "Baked-Seafood-Stuffed-Avocados-2676307") { success, getRecipe in
            XCTAssertFalse(success)
            XCTAssertNil(getRecipe)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let getSessionFake = GetSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: getSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.getRecipes(id: "Baked-Seafood-Stuffed-Avocados-2676307") { success, getRecipe in
            XCTAssertFalse(success)
            XCTAssertNil(getRecipe)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.getCorrectData, error: nil)
        let getSessionFake = GetSessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: getSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        yummlyService.getRecipes(id: "Baked-Seafood-Stuffed-Avocados-2676307") { success, getRecipe in
            XCTAssertTrue(success)
            XCTAssertNotNil(getRecipe)
            XCTAssertEqual(getRecipe?.id, "Baked-Seafood-Stuffed-Avocados-2676307")
            XCTAssertEqual(getRecipe?.rating, 4)
            XCTAssertEqual(getRecipe?.totalTime, "35 min")
            XCTAssertEqual(getRecipe?.name, "Baked Seafood Stuffed Avocados")
            XCTAssertEqual(getRecipe?.images[0].hostedLargeURL, "https://lh3.googleusercontent.com/QbRqZocTvMKbGLD5DwERLWXuOzaC456D-SsAiGxVYqRdtpqTQ49VjOyZoHlcRljkySA4RBCeQOy5sseJq-dMig=s360")
            XCTAssertEqual(getRecipe?.source.sourceRecipeURL, "https://rantsfrommycrazykitchen.com/2016/05/03/baked-seafood-stuffed-avocados-brunchweek/?utm_source=yummly&utm_medium=social&utm_campaign=social-pug")
            XCTAssertEqual(getRecipe?.ingredientLines,  [
                "4 avocados, sliced in half length-wise and pitted",
                "8 ounces chopped cooked shrimp",
                "3.25 ounces flaked fresh cooked crab",
                "1 cup finely shredded Cabots White Oak Cheddar",
                "1/2 cup finely diced vidalia onion",
                "2 eggs, beaten",
                "2 tablespoons chopped fresh parsley",
                "1 tablespoon lemon juice",
                "1/4 teaspoon seafood seasoning"
                ])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
