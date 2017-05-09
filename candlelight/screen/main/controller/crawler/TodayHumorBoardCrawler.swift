import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class TodayHumorBoardCrawler: BoardCrawler {
    
    let siteUrl = "http://www.todayhumor.co.kr/board/list.php?table=bestofbest&page="
    let contentsBaseUrl = "http://www.todayhumor.co.kr"

    func getList(page: Int) -> Future<[BoardItem]?, NoError> {
        let url = self.siteUrl + String(page + 1)
        return AlamofireRequest(url).map(parseHTML)
    }

    func parseHTML(html: String) -> [BoardItem]? {
        guard let doc = HTML(html: html, encoding: .utf8) else {
            return nil
        }
        var result = [BoardItem]()
        for content in doc.xpath("//table[contains(@class, 'table_list')]//tr[contains(@class, 'view')]") {

            let title = content.xpath("td[3]").map({ (XMLElement) -> String in
                XMLElement.text!
            }).joined(separator: " ")
            let pageIdOption = content.xpath("td[1]").first?.text.flatMap{v in Int(v)}
            let urlOption = content.xpath("td[3]//a").first?["href"]
            let authorOption = content.xpath("td[4]//a").first?.text
            let readCountOption = content.xpath("td[6]").first?.text.flatMap{v in Int(v)}
            guard let pageId = pageIdOption,
                  let url = urlOption,
                  let author = authorOption,
                  let readCount = readCountOption else {
                continue
            }
            let contentsUrl = contentsBaseUrl + url
            result.append(BoardItem(id: pageId, title: title, url: contentsUrl, author: author, date: "", readCount: readCount))
        }
        return result
    }
}
