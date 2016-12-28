import Foundation
import BrightFutures
import Result

protocol ListCrawler {
    func getList() -> Future<[ListItem], NoError>

    func getList(page: Int) -> Future<[ListItem], NoError>
}
