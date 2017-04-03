import UIKit
import Foundation
import RealmSwift

class BookmarkViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var bookmarkDataList: List<BookmarkData> = List()
    var collectionView: UICollectionView?
    var bookmarkManager: BookmarkManager = BookmarkManager()
    
    public override init() {
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
        
    }

    public func reloadCollectionView() {

    }
}
