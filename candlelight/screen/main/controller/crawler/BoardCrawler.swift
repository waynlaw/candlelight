import Foundation
import BrightFutures
import Result

protocol BoardCrawler {
    func getList() -> Future<[ListItem], NoError>

    func getList(page: Int) -> Future<[ListItem], NoError>
}
