import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class TodayHumorArticleCrawler: ArticleCrawler {
    
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
                    self.parseComment(html: html).onSuccess(callback: { (comments) in
                        complete(self.parseHTML(html: html, comments: comments))
                    })
                }
            })
        }
    }
    
    func parseComment(html: String) -> Future<[Comment], CrawlingError> {
        if let doc = HTML(html: html, encoding: .utf8) {
            return Future<[Comment], CrawlingError> { complete in
                
                let parentId = Util.matches(for: "(?<=id = \")[0-9]+(?=.;)", in: html).first!
                let parentTable = Util.matches(for: "(?<=parent_table = \")[a-zA-Z0-9_]+(?=\")", in: html).first!
                let url = "http://www.todayhumor.co.kr/board/ajax_memo_list.php?parent_table=\(parentTable)&parent_id=\(parentId)"
                Alamofire.request(url).responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        let response = JSON as! NSDictionary
                        
                        let memos = response["memos"] as! NSArray
                        
                        var comments = [Comment]()
                        for memo in memos {
                            let memoDic = memo as! NSDictionary
                            
                            let content = memoDic["memo"] as! String
                            let author = memoDic["name"] as! String
                            let regDate = memoDic["date"] as! String
                            let depth = memoDic["parent_memo_no"] as? String
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let dd = (formatter.date(from: regDate))
                            
                            if let d = depth {
                                comments.append(Comment(author: author, content: content, regDate: dd!, depth: 1))
                            } else {
                                comments.append(Comment(author: author, content: content, regDate: dd!, depth: 0))
                            }
                        }
                        
                        //example if there is an id
                        complete(.success(comments))
                    case .failure(let error):
//                        print("Request failed with error: \(error)")
                        complete(.success([Comment]()))
                    }
                }
            }
        }
        return Future<[Comment], CrawlingError> { complete in
            complete(.success([Comment]()))
        }
    }
    
    func parseHTML(html: String, comments: [Comment]) -> Result<Article, CrawlingError> {
        if let doc = HTML(html: html, encoding: .utf8) {
            let titleOption = doc.xpath("//div[contains(@class, 'viewSubjectDiv')]").first?.text
            let authorOption = doc.xpath("//div[contains(@class, 'writerInfoContents')]//div[2]//a").first?.text
            let readCountOption = doc.xpath("//div[contains(@class, 'writerInfoContents')]//div[4]").first?.text
            let contentOption = doc.xpath("//div[contains(@class, 'viewContent')]").first?.innerHTML
            let regDateOption = doc.xpath("//div[contains(@class, 'writerInfoContents')]//div[7]").first?.text
            
            guard let title = titleOption,
                let readCount = readCountOption,
                let content = contentOption,
                let regDate = regDateOption
                else {
                    print("data is invalid")
                    return .success(Article())
            }
            
            let matchedDate = Util.matches(for: "\\d+/\\d+/\\d+\\s\\d+:\\d+:\\d+", in: regDate).first!
            
            let dd = Util.dateFromString(dateStr: matchedDate, format: "yyyy/MM/dd HH:mm:ss")
            
            let author = authorOption ?? "" // TODO: should fix it when name is image.
            
            let arr = readCount.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            return .success(Article(title: title, author: author, readCount: Int(arr)!,content: content, regDate: dd, comments: comments))
        }
        return Result<Article, CrawlingError>(error: CrawlingError.contentNotFound)
    }
}
