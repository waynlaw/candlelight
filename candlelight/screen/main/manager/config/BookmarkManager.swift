//
//  SiteConfigRepos.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 22..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation
import RealmSwift

class BookmarkManager {
    
    let realm: Realm!
    
    public init() {
        realm = try! Realm()
    }
   
    func select() -> List<BookmarkData> {
        let bms: Results<BookmarkData> = realm.objects(BookmarkData.self)
        return List(bms)
    }
    
    func selectById(_ id: Int) -> BookmarkData? {
        let bm = realm.object(ofType: BookmarkData.self, forPrimaryKey:  id)
        return bm;
    }
    
    // Why real.add doesn't have return value?
    func insert(_ bm: BookmarkData) {
        try! realm.write {
            realm.add(bm)
        }
    }
    
    func upsert(_ bm: BookmarkData) {
        try! realm.write {
            realm.add(bm, update: true)
        }
    }
    
    func delete(_ bm: BookmarkData) {
        try! realm.write {
            realm.delete(bm)
        }
    }
}
