import UIKit
import Foundation
import RealmSwift

class BookmarkViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var bookmarkDataList: List<BookmarkData> = List()
    var collectionView: UICollectionView?
    var viewController: BookmarkController?
    var bookmarkManager: BookmarkManager = BookmarkManager()
    
    public init(_ viewController: BookmarkController) {
        self.viewController = viewController
        bookmarkDataList = bookmarkManager.select()
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkDataList.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfigController.collectionReuseIdentifier, for: indexPath) as! BookmarkViewCell
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        cell.setText(bookmarkDataList[indexPath.row].title)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parent = viewController,
              let bottomMenuController = parent.bottomMenuController,
              indexPath.row < bookmarkDataList.count else {
            return
        }
        let item = bookmarkDataList[indexPath.row]
        let community = Community(rawValue: item.community) ?? Community.CLIEN
        let listItem = ListItem(id: 0, title: item.title, url: item.url, author: "", date: "", readCount: 0) // TODO: fill full data.
        let addController = ContentViewController(listItem, community, bottomMenuController: bottomMenuController, bottomMenuType: .like)
        
        if let navigationController = parent.navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            navigationController.pushViewController(addController, animated: true)
        }
    }

    public func reloadCollectionView() {

    }
}
