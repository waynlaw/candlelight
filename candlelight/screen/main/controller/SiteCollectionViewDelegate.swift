import UIKit

class SiteCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let scManager: SiteConfigManager!

    let siteInfo = [
            SiteInfo(title: "clien park", crawler: ClienParkBoardCrawler()),
            SiteInfo(title: "site B", crawler: TestCrawler()),
            SiteInfo(title: "site C", crawler: TestCrawler()),
            SiteInfo(title: "site D", crawler: TestCrawler()),
            SiteInfo(title: "site E", crawler: TestCrawler())
    ]

    weak var viewController: ViewController?

    public init(_ viewController: ViewController) {
        self.viewController = viewController
       
        scManager = SiteConfigManager()
        let scs = scManager.select()
        NSLog(scs.description)
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return siteInfo.count;
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.collectionReuseIdentifier, for: indexPath) as! SiteCollectionViewCell
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        cell.setText(siteInfo[indexPath.row].title)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parent = viewController else {
            return
        }
        let addController = BoardViewController(crawler: siteInfo[indexPath.row].crawler, bottomMenuController: parent.bottomMenuController)
        parent.navigationController?.pushViewController(addController, animated: true)
    }
}
