import UIKit
import Foundation

class BookmarkViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var bookmarkDataList: Array<BookmarkData> = []
    var collectionView: UICollectionView?
    
    public override init() {
        let testData1 = BookmarkData()
        testData1.id = 0
        testData1.title = "Test Data 1"
        testData1.url = "https://github.com/"
        bookmarkDataList.append(testData1)

        let testData2 = BookmarkData()
        testData2.id = 0
        testData2.title = "Test Data 2"
        testData2.url = "https://google.com/"
        bookmarkDataList.append(testData2)
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
