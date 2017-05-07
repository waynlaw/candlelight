import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class ClienParkBoardCrawler: BoardCrawler {

    let siteUrl = "https://www.clien.net/service/board/park?&od=T31&po="
    let contentsBaseUrl = "https://www.clien.net"

    func getList(page: Int) -> Future<[BoardItem]?, NoError> {
        return Future<[BoardItem]?, NoError> { complete in
            let url = self.siteUrl + String(page)
            print(url)
            Alamofire.request(url).responseString(encoding: .utf8, completionHandler: { response in
                if let html = response.result.value {
                    complete(.success(self.parseHTML(html: html)))
                } else {
                    complete(.success(nil))
                }
            })
        }
    }

    func parseHTML(html: String) -> [BoardItem] {
        var result = [BoardItem]()
        if let doc = HTML(html: html, encoding: .utf8) {
            for content in doc.xpath("//div[contains(@class, 'post-list')]/div") {
                let linkElement = content.xpath(".//a[contains(@class, 'list-subject')]").first
                let titleOption = linkElement?.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let pageIdOption = linkElement?["href"]?.digitsOnly()
                let urlOption = linkElement?["href"]
                let authorOption = content.xpath(".//div[contains(@class, 'list-author')]").first?.text?.trim()
                let readCount = 0
                guard let pageIdText = pageIdOption,
                    let pageId = Int(pageIdText),
                    let title = titleOption,
                    let url = urlOption,
                    let author = authorOption else {
                    continue
                }
                let contentsUrl = contentsBaseUrl + url
                result.append(BoardItem(id: pageId, title: title, url: contentsUrl, author: author, date: "", readCount: readCount))
            }
        }
        return result
    }
}
