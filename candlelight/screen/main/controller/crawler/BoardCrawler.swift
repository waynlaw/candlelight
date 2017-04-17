import Foundation
import BrightFutures
import Result

protocol BoardCrawler {
    func getList(page: Int) -> Future<[ListItem]?, NoError>
}

extension BoardCrawler {
    func getList() -> Future<[ListItem]?, NoError>
    {
        return self.getList(page: 0)
    }
}