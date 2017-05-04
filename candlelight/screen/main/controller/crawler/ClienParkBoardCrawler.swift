import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class ClienParkBoardCrawler: BoardCrawler {

    let siteUrl = "http://www.clien.net/cs2/bbs/board.php?bo_table=park&page="
    let contentsBaseUrl = "http://www.clien.net/cs2/"

    func getList(page: Int) -> Future<[BoardItem]?, NoError> {
        return Future<[BoardItem]?, NoError> { complete in
            let url = self.siteUrl + String(page + 1)
            print(url)
            Alamofire.request(url).responseString(encoding: .utf8, completionHandler: { response in
                if let html = response.result.value {
                    complete(self.parseHTML(html: html))
                } else {
                    complete(.success(nil))
                }
            })
        }
    }

    func parseHTML(html: String) -> Result<Array<BoardItem>?, NoError> {
        var result = [BoardItem]()
        if let doc = HTML(html: html, encoding: .utf8) {
            for content in doc.xpath("//div[contains(@class, 'board_main')]//tr") {
                let titleOption = content.xpath("td[2]").first?.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let pageIdOption = content.xpath("td[1]").first?.text.flatMap{v in Int(v)}
                let urlOption = content.xpath("td[2]/a").first?["href"]
                let authorOption = content.xpath("td[3]").first?.text
                let readCountOption = content.xpath("td[5]").first?.text.flatMap{v in Int(v)}
                guard let pageId = pageIdOption,
                    let title = titleOption,
                    let url = urlOption,
                    let author = authorOption,
                    let readCount = readCountOption else {
                    continue
                }
                let contentsUrl = contentsBaseUrl + url.substring(from: url.index(url.startIndex, offsetBy: 3))
                result.append(BoardItem(id: pageId, title: title, url: contentsUrl, author: author, date: "", readCount: readCount))
            }
        }
        return .success(result)
    }
}
