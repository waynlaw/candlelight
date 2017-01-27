//
//  SiteConfigRepos.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 22..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation
import RealmSwift

class SiteConfigManager {
    
    let realm: Realm!
    
    public init() {
        realm = try! Realm()
    }
   
    func select() -> List<SiteConfig> {
        let scs: Results<SiteConfig> = realm.objects(SiteConfig.self)
        return List(scs)
    }
    
    func selectById(_ id: Int) -> SiteConfig? {
        let sc = realm.object(ofType: SiteConfig.self,forPrimaryKey:  id)
        return sc;
    }
    
    // Why real.add doesn't have return value?
    func insert(_ sc: SiteConfig) {
        try! realm.write {
            realm.add(sc)
        }
    }
    
    func upsert(_ sc: SiteConfig) {
        try! realm.write {
            realm.add(sc, update: true)
        }
    }
    
    func delete(_ sc: SiteConfig) {
        try! realm.write {
            realm.delete(sc)
            
        }
    }
}
