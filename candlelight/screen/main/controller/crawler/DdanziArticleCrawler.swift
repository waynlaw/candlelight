import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class DdanziArticleCrawler: ArticleCrawler {
    
    let baseUrl = "http://www.ddanzi.com/free/"
    let url: String
    
    init(_ url: String) {
        self.url = url
    }
    
    func getContent() -> Future<Article, CrawlingError>{
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
            let titleOption = doc.xpath("//div[contains(@class, 'read_header')]//h1").first?.text
            let authorOption = doc.xpath("//div[contains(@class, 'read_header')]//a[contains(@class, 'author')]").first?.text
            let readCountOption = doc.xpath("//span[contains(@class, 'read')]").first?.text
            let contentOption = doc.xpath("//div[contains(@class, 'xe_content')]").first?.innerHTML
            let commentsOption = doc.xpath("//div[@id='cmt_list']//ul//li")
            
            
            let regDateOption = doc.xpath("//div[contains(@class, 'read_header')]//p[contains(@class, 'time')]").first?.text
            
            guard let title = titleOption,
                let readCount = readCountOption,
                let content = contentOption,
                let regDate = regDateOption
                else {
                    print("data is invalid")
                    return .success(Article())
            }
            
            let author = authorOption ?? "" // TODO: should fix it when name is image.
            
            let comments = commentsOption.map({(c) -> HTMLDocument in
                HTML(html: c.toHTML!, encoding: .utf8)!
            }).map({ (cts) -> Comment in
                let author = (cts.xpath("//h3[contains(@class, 'author')]").first?.text)!
                let regDate = (cts.xpath("//p[contains(@class, 'time')]").first?.text)!
                
                let dd = Util.dateFromString(dateStr: regDate, format: "yyyy-MM-dd HH:mm:ss")
                
                let className = (cts.xpath("//div").first?.className)!

                var depth = 0
                if className.contains("indent") {
                    depth = Int(className.substring(from: className.index(className.endIndex, offsetBy: -1)))!
                }
                
                let content = (cts.xpath("//div[contains(@class, 'xe_content')]").first?.text)!
                
                return Comment(author: author, content: content, regDate: dd, depth: depth)
            })
            
            let arr = readCount.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            let dd = Util.dateFromString(dateStr: regDate, format: "yyyy-MM-dd HH:mm")
            
            return .success(Article(title: title, author: author, readCount: Int(arr)!,content: content, regDate:dd, comments: comments))
        }
        return Result<Article, CrawlingError>(error: CrawlingError.contentNotFound)
    }
}
