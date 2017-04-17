
import Foundation

enum Community: Int {
    case CLIEN
    case DDANZI
    case TODAY_HUMOR
    case TOTAL_COUNT
}

func name(_ community: Community?) -> String {
    let sites = [
        "클리앙",
        "딴지일보",
        "오늘의유머"
    ]

    let idx = community?.rawValue ?? -1
    if (0 > idx || sites.count <= idx) {
        return "UNKNOWN"
    }
    return sites[idx]
}

func boardCrawler(_ community: Community?) -> BoardCrawler {
    let crawlers: [() -> BoardCrawler] = [
        {() in return ClienParkBoardCrawler()},
        {() in return DdanziBoardCrawler()},
        {() in return TodayHumorBoardCrawler()}
    ]

    let idx = community?.rawValue ?? -1
    if (0 > idx || crawlers.count <= idx) {
        return ClienParkBoardCrawler()
    }
    return crawlers[idx]()
}
//community
func articleCrawler(_ community: Community?, _ url: String) -> ArticleCrawler {
    let crawlers: [(String) -> ArticleCrawler] = [
            {(url) in return ClienParkArticleCrawler(url)},
            {(url) in return DdanziArticleCrawler(url)},
            {(url) in return TodayHumorArticleCrawler(url)}
    ]

    let idx = community?.rawValue ?? -1
    if (0 > idx || crawlers.count <= idx) {
        return ClienParkArticleCrawler(url)
    }
    return crawlers[idx](url)
}