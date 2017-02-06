import Foundation

class SiteInfo {
    let title: String
    let crawler: ListCrawler
    let isOn: Bool

    init(title: String, crawler: ListCrawler, isOn: Bool = false) {
        self.title = title
        self.crawler = crawler
        self.isOn = isOn
    }
}
