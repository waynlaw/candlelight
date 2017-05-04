//
//  PieMenuLocationManager.swift
//  candlelight
//
//  Created by Lawrence on 2017. 5. 4..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//
import Foundation
import RealmSwift

class PieMenuLocationManager {
    
    let realm: Realm!
    
    public init() {
        realm = try! Realm()
    }
    
    func select() -> Bool {
        let pieMenuLocationOptions: PieMenuLocation? = realm.object(ofType: PieMenuLocation.self, forPrimaryKey: 0)

        if let pieMenuLocation = pieMenuLocationOptions {
            return pieMenuLocation.location
        } else {
            let pieMenu = PieMenuLocation()
            pieMenu.id = 0
            pieMenu.location = false
            try! realm.write {
                realm.add(pieMenu, update: true)
            }
            return false
        }
    }
    
    func toggle() {
        let pieMenuLocation: PieMenuLocation? = realm.object(ofType: PieMenuLocation.self, forPrimaryKey: 0)
        try! realm.write {
            pieMenuLocation!.location = !pieMenuLocation!.location
            realm.add(pieMenuLocation!, update: true)
        }
    }
}
