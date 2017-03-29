import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class ClienParkArticleCrawler: ContentCrawler {

    let baseUrl = "http://www.clien.net/cs2/"
    let url: String

    init(_ url: String) {
        self.url = baseUrl + url.substring(from: url.index(url.startIndex, offsetBy: 3))
    }

    func getContent() -> Future<Article, CrawlingError>{
        return result()
    }

    func result() -> Future<Article, CrawlingError> {
        return Future<Article, CrawlingError> { complete in
            Alamofire.request(url).responseString(encoding: .utf8, completionHandler: { response in
                        if let html = response.result.value {
                            complete(self.parseHTML(html: html))
                        }
                    })
        }
    }

    func parseHTML(html: String) -> Result<Article, CrawlingError> {
        if let doc = HTML(html: html, encoding: .utf8) {
            let titleOption = doc.xpath("//div[contains(@class, 'view_title')]").first?.text
            let authorOption = doc.xpath("//p[contains(@class, 'user_info')]//span").first?.text
            let readCountOption = doc.xpath("//p[contains(@class, 'post_info')]").first?.text
            let contentOption = doc.xpath("//div[@id='resContents']").first?.innerHTML
           
            guard let title = titleOption,
                  let author = authorOption,
                  let readCount = readCountOption,
                  let content = contentOption
                else {
                    NSLog("failed")
                    return .success(Article())
            }
            
            NSLog("there")
            NSLog(title)
            NSLog(author)
            let arr = readCount.components(separatedBy: ",")[1].components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            NSLog(arr)
            NSLog(content)
            return .success(Article(title: title, author: author, readCount: Int(arr)!,content: content, regDate: NSDate(), comments:[Comment]()))
        }
        return Result<Article, CrawlingError>(error: CrawlingError.contentNotFound)
    }
}
