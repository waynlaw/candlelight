import Foundation
import BrightFutures
import Result

protocol BoardCrawler {
    func getList(page: Int) -> Future<[BoardItem]?, NoError>
}

extension BoardCrawler {
    func getList() -> Future<[BoardItem]?, NoError> {
        return self.getList(page: 0)
    }
}
