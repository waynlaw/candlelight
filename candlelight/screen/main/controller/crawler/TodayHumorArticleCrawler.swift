import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class TodayHumorArticleCrawler: ArticleCrawler {
    
    let baseUrl = "http://www.todayhumor.co.kr"
    let url: String
    
    init(_ url: String) {
        self.url = baseUrl + url
    }
    
    func getContent() -> Future<Article, CrawlingError>{
        return result()
    }
    
    func result() -> Future<Article, CrawlingError> {
        return Future<Article, CrawlingError> { complete in
            Alamofire.request(url).responseData(completionHandler: { response in
                if let htmlWithoutEncoding = response.result.value,
                    let html = String(data: DataEncodingHelper.healing(htmlWithoutEncoding), encoding: .utf8) {
                    self.parseComment(html: html).onSuccess(callback: { (comment) in
                        complete(self.parseHTML(html: html, comment: comment))
                    })
                }
            })
        }
    }
    
    func parseComment(html: String) -> Future<NSDictionary, CrawlingError> {
        if let doc = HTML(html: html, encoding: .utf8) {
            return Future<NSDictionary, CrawlingError> { complete in
                Alamofire.request("http://www.todayhumor.co.kr/board/ajax_memo_list.php?parent_table=sisa&parent_id=896044&last_memo_no=0&_=1492426501849").responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        
                        let response = JSON as! NSDictionary
                        
                        //example if there is an id
                        complete(.success(response))
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        complete(.success(NSDictionary()))
                    }
                }
            }
        }
        return Future<NSDictionary, CrawlingError> { complete in
            complete(.success(NSDictionary()))
        }
    }
    
    func parseHTML(html: String, comment: NSDictionary) -> Result<Article, CrawlingError> {
        if let doc = HTML(html: html, encoding: .utf8) {
            let titleOption = doc.xpath("//div[contains(@class, 'viewSubjectDiv')]").first?.text
            let authorOption = doc.xpath("//div[contains(@class, 'writerInfoContents')]//div[2]//a").first?.text
            let readCountOption = doc.xpath("//div[contains(@class, 'writerInfoContents')]//div[4]").first?.text
            let contentOption = doc.xpath("//div[contains(@class, 'viewContent')]").first?.innerHTML
            
            guard let title = titleOption,
                let readCount = readCountOption,
                let content = contentOption
                else {
                    print("data is invalid")
                    return .success(Article())
            }
            
            // comment parsing해서 데이터를 얻어야 함
            print(comment.count.description)
            
            let author = authorOption ?? "" // TODO: should fix it when name is image.
            
            let arr = readCount.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            return .success(Article(title: title, author: author, readCount: Int(arr)!,content: content, regDate: Date(), comments: [Comment]()))
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
