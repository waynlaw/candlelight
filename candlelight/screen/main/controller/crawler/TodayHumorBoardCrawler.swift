import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class TodayHumorBoardCrawler: BoardCrawler {
    
    let siteUrl = "http://www.todayhumor.co.kr/board/list.php?table=bestofbest&page="
    
    func getList() -> Future<[ListItem], NoError> {
        return result(page: 0)
    }
    
    func getList(page: Int) -> Future<[ListItem], NoError> {
        return result(page: page)
    }
    
    func result(page: Int) -> Future<[ListItem], NoError> {
        return Future<[ListItem], NoError> { complete in
            let url = self.siteUrl + String(page + 1)
            print(url)
            Alamofire.request(url).responseString(encoding: .utf8, completionHandler: { response in
                if let html = response.result.value {
                    complete(self.parseHTML(html: html))
                }
            })
        }
    }
    
    func parseHTML(html: String) -> Result<Array<ListItem>, NoError> {
        var result = [ListItem]()
        if let doc = HTML(html: html, encoding: .utf8) {
            for content in doc.xpath("//table[contains(@class, 'table_list')]//tr[contains(@class, 'view')]") {
                
                let titleOption = content.xpath("td[3]//a").first?.text
                let pageIdOption = content.xpath("td[1]").first?.text.flatMap{v in Int(v)}
                let urlOption = content.xpath("td[3]//a").first?["href"]
                let authorOption = content.xpath("td[4]//a").first?.text
                let readCountOption = content.xpath("td[6]").first?.text.flatMap{v in Int(v)}
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
