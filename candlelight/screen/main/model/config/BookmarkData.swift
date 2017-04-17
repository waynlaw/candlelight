//
//  SiteConfig.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 22..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation
import RealmSwift

class BookmarkData: Object {
    dynamic var id: Int = 0
    dynamic var community: Int = 0
    dynamic var title: String = ""
    dynamic var url: String = ""

    override static func primaryKey() -> String? {
        return "title"
    }

    override static func indexedProperties() -> [String] {
        return ["title"]
    }
}
