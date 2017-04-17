import UIKit
import Foundation

class CommunityViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let scManager: SiteConfigManager = SiteConfigManager()

    var siteInfos: Array<SiteInfo> = []
    
    weak var communityController: CommunityController?
    weak var collectionView: UICollectionView? = nil
    
    public init(_ communityController: CommunityController) {
        
        self.communityController = communityController
        
        // load settings
        let scs = scManager.select()
        
        for sc in scs {
            if let community = Community(rawValue: sc.id) {
                siteInfos.append(SiteInfo(community: community, title: sc.name, isOn: sc.isOn))
            }
        }
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = siteInfos.filter{ $0.isOn }.count
        return count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfigController.collectionReuseIdentifier, for: indexPath) as! SiteCollectionViewCell
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        cell.setText(siteInfos[indexPath.row].title)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parent = communityController else {
            return
        }
        let addController = BoardViewController(community: siteInfos[indexPath.row].community, bottomMenuController: parent.bottomMenuController)
        parent.navigationController?.pushViewController(addController, animated: true)
    }
    
    public func reloadCollectionView(){
        siteInfos.removeAll()
        
        // load settings
        let scs = scManager.select()
        
        for sc in scs {
            if sc.isOn,
               let community = Community(rawValue: sc.id) {
                siteInfos.append(SiteInfo(community: community, title: sc.name, isOn: sc.isOn))
            }
        }
        collectionView?.reloadData()
    }
}
