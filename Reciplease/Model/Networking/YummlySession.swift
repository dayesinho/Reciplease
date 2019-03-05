//
//  YummlySession.swift
//  Reciplease
//
//  Created by Mac Hack on 27/01/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import Foundation
import Alamofire

class YummlySession: YummlyProtocol {
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url).responseJSON { responseData in
            completionHandler(responseData)
        }
    }
}
