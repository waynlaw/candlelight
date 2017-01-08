//
//  SiteConfigDelegate.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 8..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import UIKit

class SiteConfigDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        let sites = [
            "클리앙",
            "딴지일보"
        ]
        
        weak var viewController: ConfigController?
        
        public init(_ viewController: ConfigController) {
            self.viewController = viewController
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
            
            sw.tintColor = UIColor.lightGray
            sw.thumbTintColor = UIColor.white
            sw.onTintColor = UIColor.lightGray
            
            cell.addSubview(sw)
            
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let parent = viewController else {
                return
            }
        }
}
