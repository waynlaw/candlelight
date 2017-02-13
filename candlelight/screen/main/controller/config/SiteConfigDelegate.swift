//
//  SiteConfigDelegate.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 8..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import UIKit
import RealmSwift

class SiteConfigDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    let sites = [
        "클리앙",
        "딴지일보"
    ]
    
    let scManager: SiteConfigManager!
    
    weak var configController: ConfigController?
        
    public init(_ configController: ConfigController) {
        self.configController = configController
        scManager = SiteConfigManager()
    }
        
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sites.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // You can get called index to check the value of indexPath.row
        let index = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityController.collectionReuseIdentifier, for: indexPath) as! SiteCollectionViewCell
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        cell.setText(sites[index])
        
        let sw = UISwitch(frame: CGRect(x: cell.bounds.width - 60, y: 10, width: 0, height: 0))
        
        sw.tag = indexPath.item
        sw.tintColor = UIColor.lightGray
        sw.thumbTintColor = UIColor.white
        sw.onTintColor = UIColor.lightGray
        
        if let sc = scManager.selectById(indexPath.row) {
            sw.isOn = sc.isOn
        }
        
        cell.addSubview(sw)
        
        sw.addTarget(self, action: #selector(switchValueDidChange), for: UIControlEvents.valueChanged)
        
        return cell
    }

    public func switchValueDidChange(sender: UISwitch){
        
        // You can get called index to check the value of sender.tag
        let index = sender.tag
        
        if sender.tag > 3 {
            NSLog("error")
        }
        
        // TODO : only upsert. is it Ok?
        let sc = SiteConfig()
        sc.id = index
        sc.name = sites[index]
        sc.isOn = sender.isOn
        
        scManager.upsert(sc)
    }
}
