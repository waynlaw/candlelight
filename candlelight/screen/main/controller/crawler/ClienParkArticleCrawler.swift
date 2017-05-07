import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class ClienParkArticleCrawler: ArticleCrawler {

    let url: String

    init(_ url: String) {
        self.url = url
    }

    func getContent() -> Future<Article, CrawlingError> {
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

            let titleOption = doc.xpath("//div[contains(@class, 'title-subject')]").first?.text?.trim()
            let authorOption = doc.xpath("//span[contains(@class, 'contact-name')]/button").first?.text?.trim()
            let readCountOption = doc.xpath("//span[contains(@class, 'view-count')]").first?.text?.trim()
            let contentOption = doc.xpath("//div[contains(@class, 'post-content')]").first?.innerHTML
            let postTimeOption = doc.xpath("//div[contains(@class, 'post-time')]").first?.text?.trim()

            guard let title = titleOption,
                  let readCountText = readCountOption,
                  let content = contentOption,
                  let postTime = postTimeOption
                    else {
                print("data is invalid")
                return .success(Article())
            }

            let author = authorOption ?? "" // TODO: should fix it when name is image.
            let comments = [Comment]()

            let dd = Util.dateFromString(dateStr: postTime, format: "yyyy-MM-dd HH:mm:ss")
            let readCount = Int(readCountText.digitsOnly()) ?? 0
            return .success(Article(title: title, author: author, readCount: readCount, content: content, regDate: dd, comments: comments))
        }
        return Result<Article, CrawlingError>(error: CrawlingError.contentNotFound)
    }
}
