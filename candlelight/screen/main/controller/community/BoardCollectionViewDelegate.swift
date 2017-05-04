import UIKit

class BoardCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var boardItems: [BoardItem] = []
    let community: Community

    weak var viewController: BoardViewController? = nil
    weak var collectionView: UICollectionView? = nil

    public init(_ viewController: BoardViewController, _ community: Community) {
        self.viewController = viewController
        self.community = community
    }

    func setBoardList(boardItems: [BoardItem]) {
        self.boardItems = boardItems

        collectionView?.reloadData()
        collectionView?.performBatchUpdates(nil)
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardItems.count + 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityController.collectionReuseIdentifier, for: indexPath) as! SiteCollectionViewCell
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        if boardItems.count == indexPath.row {
            cell.setText("")
            viewController?.onNeedToMoreList()
            return cell
        } else {
            cell.setText(boardItems[indexPath.row].title)
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parent = viewController,
            let bottomMenuController = parent.bottomMenuController,
            indexPath.row < boardItems.count else {
            return
        }
        let item = boardItems[indexPath.row]
        let addController = ContentViewController(item, community, bottomMenuController: bottomMenuController, bottomMenuType: .home)
        if let navigationController = parent.navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            navigationController.pushViewController(addController, animated: true)
        }
    }
}
