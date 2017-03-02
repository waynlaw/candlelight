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
        let scs: Results<BookmarkData> = realm.objects(BookmarkData.self)
        return List(scs)
    }
    
    func selectById(_ id: Int) -> BookmarkData? {
        let sc = realm.object(ofType: BookmarkData.self, forPrimaryKey:  id)
        return sc;
    }
    
    // Why real.add doesn't have return value?
    func insert(_ sc: BookmarkData) {
        try! realm.write {
            realm.add(sc)
        }
    }
    
    func upsert(_ sc: BookmarkData) {
        try! realm.write {
            realm.add(sc, update: true)
        }
    }
    
    func delete(_ sc: BookmarkData) {
        try! realm.write {
            realm.delete(sc)
            
        }
    }
}
