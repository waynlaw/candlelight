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
            
            guard let title = titleOption,
                let readCount = readCountOption,
                let content = contentOption
                else {
                    print("data is invalid")
                    return .success(Article())
            }
            
            let author = authorOption ?? "" // TODO: should fix it when name is image.
            
            let comments = commentsOption.map({(c) -> HTMLDocument in
                HTML(html: c.toHTML!, encoding: .utf8)!
            }).map({ (cts) -> Comment in
                let author = (cts.xpath("//h3[contains(@class, 'author')]").first?.text)!
                let date = (cts.xpath("//p[contains(@class, 'time')]").first?.text)!
                
                let className = (cts.xpath("//div").first?.className)!

                var depth = 0
                if className.contains("indent") {
                    depth = Int(className.substring(from: className.index(className.endIndex, offsetBy: -1)))!
                }
                
                let content = (cts.xpath("//div[contains(@class, 'xe_content')]").first?.text)!
                
                return Comment(author: author, content: content, regDate: NSDate(), depth: depth)
//                return Comment()
            })
            
            let arr = readCount.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return .success(Article(title: title, author: author, readCount: Int(arr)!,content: content, regDate: NSDate(), comments: comments))
            
        }
        return Result<Article, CrawlingError>(error: CrawlingError.contentNotFound)
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
