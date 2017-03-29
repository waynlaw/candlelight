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
            let commentsOption = doc.xpath("//div[contains(@class, 'reply_base')]")
           
            guard let title = titleOption, let author = authorOption,
                  let readCount = readCountOption,
                  let content = contentOption
                else {
                    return .success(Article())
            }
         
            let comments = commentsOption.map({(c) -> HTMLDocument in
                HTML(html: c.toHTML!, encoding: .utf8)!
            }).map({ (cts) -> Comment in
                guard let b = cts.xpath("//div").first?["style"] else {
                        return Comment()
                }
                let depth = b.components(separatedBy: ":")[1].components(separatedBy: "px")[0] == "1" ? 0 : 1
                let author = (cts.xpath("//li[contains(@class, 'user_id')]").first?.text)!
                let date = (cts.xpath("//li[2]").first?.text)!
                let content = (cts.xpath("//textarea").first?.text)!
                
                return Comment(author: author, content: content, regDate: NSDate(), depth: depth)
            })
            
            let arr = readCount.components(separatedBy: ",")[1].components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return .success(Article(title: title, author: author, readCount: Int(arr)!,content: content, regDate: NSDate(), comments: comments))
        }
        return Result<Article, CrawlingError>(error: CrawlingError.contentNotFound)
    }
}
