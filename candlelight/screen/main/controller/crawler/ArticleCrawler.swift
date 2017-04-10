import Foundation
import BrightFutures
import Result

protocol ArticleCrawler {
    func getContent() -> Future<Article, CrawlingError>
}
