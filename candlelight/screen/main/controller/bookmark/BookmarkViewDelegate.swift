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
        bookmarkDataList = List(bookmarkManager.select().reversed())
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
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(BookmarkViewDelegate.swipeLeft))
        swipeLeft.direction = .left
        
        cell.addGestureRecognizer(swipeLeft)
        
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
        let boardItem = BoardItem(id: 0, title: item.title, url: item.url, author: "", date: "", readCount: 0) // TODO: fill full data.
        let addController = ContentViewController(boardItem, community, bottomMenuController: bottomMenuController, bottomMenuType: .like)
        
        if let navigationController = parent.navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            navigationController.pushViewController(addController, animated: true)
        }
    }

    public func reloadCollectionView() {
        bookmarkDataList = List(bookmarkManager.select().reversed())
        collectionView?.reloadData()
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! BookmarkViewCell

        let point = sender.location(in: self.collectionView)
        let indexPath = self.collectionView!.indexPathForItem(at: point)
        
        let deletedData = bookmarkDataList.remove(at: indexPath!.row)
        bookmarkManager.delete(deletedData)
        
        cell.setText("")
        
        UIView.transition(with: cell.contentView, duration: 1, options: .curveEaseIn, animations: {
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width - 100, height: cell.frame.height
            )
            
            cell.backgroundColor = UIColor.darkGray
        }, completion: { finished in
            self.collectionView?.reloadData()
        })
    }
}
