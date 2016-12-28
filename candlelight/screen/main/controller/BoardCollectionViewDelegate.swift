import UIKit

class BoardCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var boardItems: [ListItem] = []

    weak var viewController: BoardViewController? = nil
    weak var collectionView: UICollectionView? = nil

    public init(_ viewController: BoardViewController) {
        self.viewController = viewController
    }

    func setBoardList(boardItems: [ListItem]) {
        self.boardItems = boardItems

        collectionView?.reloadData()
        collectionView?.performBatchUpdates(nil)
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardItems.count;
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.collectionReuseIdentifier, for: indexPath) as! SiteCollectionViewCell
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        cell.setText(boardItems[indexPath.row].title)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}