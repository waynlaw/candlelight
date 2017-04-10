import Foundation

class SiteInfo {
    let title: String
    let crawler: BoardCrawler
    let isOn: Bool

    init(title: String, crawler: BoardCrawler, isOn: Bool = false) {
        self.title = title
        self.crawler = crawler
        self.isOn = isOn
    }
}
