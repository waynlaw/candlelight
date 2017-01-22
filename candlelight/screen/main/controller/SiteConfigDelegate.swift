//
//  SiteConfigDelegate.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 8..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import UIKit
import SQLite

class SiteConfigDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    let sites = [
        "클리앙",
        "딴지일보"
    ]
    
    let db: Connection?
    
    weak var viewController: ConfigController?
        
    public init(_ viewController: ConfigController) {
        self.viewController = viewController
        
        do {
            db = try Connection("db.sqlite3")
        } catch _ {
            db = nil
        }
        
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        
        
        //db.run
        
    }
        
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sites.count;
    }
        
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.collectionReuseIdentifier, for: indexPath) as! SiteCollectionViewCell
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        cell.setText(sites[indexPath.row])
        
        let sw = UISwitch(frame: CGRect(x: cell.bounds.width - 60, y: 10, width: 0, height: 0))
        
        sw.tag = indexPath.item
        sw.tintColor = UIColor.lightGray
        sw.thumbTintColor = UIColor.white
        sw.onTintColor = UIColor.lightGray
        
        cell.addSubview(sw)
        
        sw.addTarget(self, action: #selector(switchValueDidChange), for: UIControlEvents.valueChanged)
        
        return cell
    }

    public func switchValueDidChange(sender: UISwitch){
        switch (sender.tag) {
        case 0:
            NSLog("클리앙")
        case 1:
            NSLog("딴지일보")
        default:
            NSLog("호이호이")
        }
    }
}
