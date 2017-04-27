import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class ClienParkArticleCrawler: ArticleCrawler {

    let baseUrl = "http://www.clien.net/cs2/"
    let url: String

    init(_ url: String) {
        self.url = baseUrl + url.substring(from: url.index(url.startIndex, offsetBy: 3))
    }

    func getContent() -> Future<Article, CrawlingError> {
        return result()
    }

    func result() -> Future<Article, CrawlingError> {
        return Future<Article, CrawlingError> { complete in
            Alamofire.request(url).responseData(completionHandler: { response in
                if let htmlWithoutEncoding = response.result.value,
                   let html = String(data: DataEncodingHelper.healing(htmlWithoutEncoding), encoding: .utf8) {
                    complete(self.parseHTML(html: html))
                }
            })
        }
    }

    func parseHTML(html: String) -> Result<Article, CrawlingError> {
        if let doc = HTML(html: html, encoding: .utf8) {
            // remove a signature
            if let signature = doc.xpath("//div[contains(@class, 'signature')]").first {
                signature.parent?.removeChild(signature)
            }

            let titleOption = doc.xpath("//div[contains(@class, 'view_title')]").first?.text
            let authorOption = doc.xpath("//p[contains(@class, 'user_info')]//span").first?.text
            let readCountOption = doc.xpath("//p[contains(@class, 'post_info')]").first?.text
            let contentOption = doc.xpath("//div[@id='resContents']").first?.innerHTML
            let commentsOption = doc.xpath("//div[contains(@class, 'reply_base')]")

            guard let title = titleOption,
                  let readCount = readCountOption,
                  let content = contentOption
                    else {
                print("data is invalid")
                return .success(Article())
            }

            let author = authorOption ?? "" // TODO: should fix it when name is image.
            let comments = commentsOption.map({ (c) -> HTMLDocument in
                HTML(html: c.toHTML!, encoding: .utf8)!
            }).map({ (cts) -> Comment in
                guard let b = cts.xpath("//div").first?["style"] else {
                    return Comment()
                }
                let depth = b.components(separatedBy: ":")[1].components(separatedBy: "px")[0] == "1" ? 0 : 1

                let authorHtml = cts.xpath("//li[contains(@class, 'user_id')]").first

                var author = ""
                if (authorHtml?.innerHTML!.contains("img"))! {
                    author = Util.matches(for: "[a-z0-9]+(?=.gif)", in: (authorHtml?.innerHTML)!).first!
                } else {
                    author = (authorHtml?.text)!
                }

                let regDate = (cts.xpath("//li[2]").first?.text)!
                let content = (cts.xpath("//textarea").first?.text)!

                let matchedDate = Util.matches(for: "\\d+-\\d+-\\d+\\s\\d+:\\d+", in: regDate).first!
                let dd = Util.dateFromString(dateStr: matchedDate, format: "yyyy-MM-dd HH:mm")
                
                return Comment(author: author, content: content, regDate: dd, depth: depth)
            })

            let regDate = readCount.components(separatedBy: ",")[0]
            let dd = Util.dateFromString(dateStr: regDate, format: "yyyy-MM-dd HH:mm")
            
            let arr = readCount.components(separatedBy: ",")[1].components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            
            return .success(Article(title: title, author: author, readCount: Int(arr)!, content: content, regDate: dd, comments: comments))
        }
        return Result<Article, CrawlingError>(error: CrawlingError.contentNotFound)
    }
}
