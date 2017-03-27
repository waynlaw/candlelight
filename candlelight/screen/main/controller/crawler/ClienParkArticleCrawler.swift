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
            print(url)
            Alamofire.request(url).responseString(encoding: .utf8, completionHandler: { response in
                        if let html = response.result.value {
                            complete(self.parseHTML(html: html))
                        }
                    })
        }
    }

    func parseHTML(html: String) -> Result<Article, CrawlingError> {
        if let doc = HTML(html: html, encoding: .utf8) {
            if let content = doc.xpath("//span[@id='writeContents']").first,
                let bodyText = content.toHTML {
                return .success(Article())
            }
        }
        return Result<Article, CrawlingError>(error: CrawlingError.contentNotFound)
    }
}
