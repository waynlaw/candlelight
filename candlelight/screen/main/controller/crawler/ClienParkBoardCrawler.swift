import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class ClienParkBoardCrawler: BoardCrawler {

    let siteUrl = "http://www.clien.net/cs2/bbs/board.php?bo_table=park&page="

    func getList(page: Int) -> Future<[ListItem]?, NoError> {
        return Future<[ListItem]?, NoError> { complete in
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

    func parseHTML(html: String) -> Result<Array<ListItem>?, NoError> {
        var result = [ListItem]()
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
                result.append(ListItem(id: pageId, title: title, url: url, author: author, date: "", readCount: readCount))
            }
        }
        return .success(result)
    }
}
