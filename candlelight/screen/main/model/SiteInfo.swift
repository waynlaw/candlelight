import Foundation

class SiteInfo {
    let title: String
    let crawler: ListCrawler

    init(title: String, crawler: ListCrawler) {
        self.title = title
        self.crawler = crawler
    }
}
