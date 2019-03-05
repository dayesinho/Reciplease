//
//  YummlyProtocol.swift
//  Reciplease
//
//  Created by Mac Hack on 25/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import Foundation
import Alamofire

protocol YummlyProtocol {
    var urlSearchAPI: String { get }
 
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void)
}

extension YummlyProtocol {
    
    var appID: String {
        let appID = "_app_id=a48a3490"
        
        return appID
    }
    
    var appKey: String {
        let appKey = "&_app_key=3cc1c55387680f3c04b33ef49f913d1b"
        
        return appKey
    }
    
    var urlSearchAPI: String {
   
        let urlSearchRecipes = "http://api.yummly.com/v1/api/recipes?"
        
        return urlSearchRecipes
    }
    
    var urlGetAPI: String {
        
        let urlGetRecipes = "http://api.yummly.com/v1/api/recipe/"
        
        return urlGetRecipes
    }
}

