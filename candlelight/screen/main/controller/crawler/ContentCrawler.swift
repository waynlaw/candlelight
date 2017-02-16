import Foundation
import BrightFutures
import Result

protocol ContentCrawler {
    func getContent() -> Future<ContentData, CrawlingError>
}
