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

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
