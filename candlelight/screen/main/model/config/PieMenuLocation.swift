//
//  PieMenuLocation.swift
//  candlelight
//
//  Created by Lawrence on 2017. 5. 4..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation
import RealmSwift

class PieMenuLocation: Object {
    dynamic var id: Int = 0
    dynamic var location: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
}
