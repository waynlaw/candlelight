import UIKit

class SiteCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let siteInfo = [
            SiteInfo(title: "site A", crawler: TestCrawler()),
            SiteInfo(title: "site B", crawler: TestCrawler()),
            SiteInfo(title: "site C", crawler: TestCrawler()),
            SiteInfo(title: "site D", crawler: TestCrawler()),
            SiteInfo(title: "site E", crawler: TestCrawler())
    ]

    weak var viewController: ViewController? = nil

    public init(_ viewController: ViewController) {
        self.viewController = viewController
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
        let addController = BoardViewController(crawler: siteInfo[indexPath.row].crawler)

        addController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        addController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        viewController?.present(addController, animated: true, completion: nil)
    }
}