//
//  String.swift
//  Reciplease
//
//  Created by Mac Hack on 11/02/2019.
//  Copyright © 2019 Mac Hack. All rights reserved.
//

import UIKit

extension String {
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    var updateSizeOfUrlImageString: String {
        return self.dropLast(2) + "360"
    }
}
