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

    func getContent() -> Future<Article?, NoError> {
        // public func flatMap<U>(_ f: @escaping (Value.Value) -> Future<U, Value.Error>) -> Future<U, Value.Error> {
        return AlamofireRequest(url).flatMap(getContentWithHtml)
    }

    func getContentWithHtml(html: String) -> Future<Article?, NoError> {
        let commentUrl = parseCommentUrl(html: html)
        let parseContent = {self.parseHTML(html: html, comments: $0)}
        return AlamofireRequestAsJson(commentUrl).map(parseComment).map(parseContent)
    }

    func parseCommentUrl(html: String) -> String {
        let parentId = Util.matches(for: "(?<=id = \")[0-9]+(?=.;)", in: html).first!
        let parentTable = Util.matches(for: "(?<=parent_table = \")[a-zA-Z0-9_]+(?=\")", in: html).first!
        return "http://www.todayhumor.co.kr/board/ajax_memo_list.php?parent_table=\(parentTable)&parent_id=\(parentId)"
    }

    func parseComment(_ response: DataResponse<Any>) -> [Comment] {
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

                if depth != nil {
                    comments.append(Comment(author: author, content: content, regDate: dd!, depth: 1))
                } else {
                    comments.append(Comment(author: author, content: content, regDate: dd!, depth: 0))
                }
            }

            return comments
        case .failure(_):
            return [Comment]()
        }
    }
    
    func parseHTML(html: String, comments: [Comment]) -> Article? {
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
                    return nil
            }
            
            let matchedDate = Util.matches(for: "\\d+/\\d+/\\d+\\s\\d+:\\d+:\\d+", in: regDate).first!
            
            let dd = Util.dateFromString(dateStr: matchedDate, format: "yyyy/MM/dd HH:mm:ss")
            
            let author = authorOption ?? "" // TODO: should fix it when name is image.
            
            let arr = readCount.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            return Article(title: title, author: author, readCount: Int(arr)!,content: content, regDate: dd, comments: comments)
        }
        return nil
    }
}
