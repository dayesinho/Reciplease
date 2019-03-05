//
//  SearchServiceTests.swift
//  Reciplease
//
//  Created by Mac Hack on 09/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import XCTest
@testable import Reciplease

//class SearchServiceTests: XCTestCase {
//    
//    func testSearchRecipesShouldPostFailedCallback() {
//        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
//        let searchSessionFake = SearchSessionFake(fakeResponse: fakeResponse)
//        let searchService = SearchRecipes(from: searchSessionFake)
//        
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        searchService.searchRecipes { success, responseRecipes in
//            
//            XCTAssertFalse(success)
//            XCTAssertNil(responseRecipes)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 0.01)
//    }
//}
