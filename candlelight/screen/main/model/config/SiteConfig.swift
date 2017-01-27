//
//  SiteConfig.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 22..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation
import RealmSwift

class SiteConfig: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var isOn: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}
