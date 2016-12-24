import UIKit

class SiteCollectionViewDelegate: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let siteInfo = ["site A", "site B", "site C", "site D", "site E"]

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return siteInfo.count;
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.collectionReuseIdentifier, for: indexPath) as! SiteCollectionViewCell
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        cell.setText(siteInfo[indexPath.row])
        return cell
    }
}