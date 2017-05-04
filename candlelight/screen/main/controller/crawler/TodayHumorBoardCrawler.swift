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
        return Future<[BoardItem]?, NoError> { complete in
            let url = self.siteUrl + String(page + 1)
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
            for content in doc.xpath("//table[contains(@class, 'table_list')]//tr[contains(@class, 'view')]") {
                
                let title = content.xpath("td[3]").map({ (XMLElement) -> String in
                    XMLElement.text!
                }).joined(separator: " ")
                let pageIdOption = content.xpath("td[1]").first?.text.flatMap{v in Int(v)}
                let urlOption = content.xpath("td[3]//a").first?["href"]
                let authorOption = content.xpath("td[4]//a").first?.text
                let readCountOption = content.xpath("td[6]").first?.text.flatMap{v in Int(v)}
                guard let pageId = pageIdOption,
//                    let title = titleOption,
                    let url = urlOption,
                    let author = authorOption,
                    let readCount = readCountOption else {
                        continue
                }
                let contentsUrl = contentsBaseUrl + url
                result.append(BoardItem(id: pageId, title: title, url: contentsUrl, author: author, date: "", readCount: readCount))
            }
        }
        return .success(result)
    }
}
