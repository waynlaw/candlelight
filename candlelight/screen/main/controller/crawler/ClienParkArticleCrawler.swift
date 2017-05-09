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

    func getContent() -> Future<Article?, NoError> {
        return getComment().zip(AlamofireRequest(url)).map(parseHTML)
    }

    func parseHTML(comments:[Comment], html: String) -> Article? {
        if let doc = HTML(html: html, encoding: .utf8) {
            let titleOption = doc.xpath("//div[contains(@class, 'title-subject')]").first?.text?.trim()
            let authorOption = doc.xpath("//span[contains(@class, 'contact-name')]/button").first?.text?.trim()
            let readCountOption = doc.xpath("//span[contains(@class, 'view-count')]").first?.text?.trim()
            let contentOption = doc.xpath("//div[contains(@class, 'post-content')]").first?.innerHTML
            let postTimeOption = doc.xpath("//div[contains(@class, 'post-time')]").first?.text?.trim()
            let commentsOption = doc.xpath("//div[contains(@class, 'comment-row')]")

            guard let title = titleOption,
                  let readCountText = readCountOption,
                  let content = contentOption,
                  let postTime = postTimeOption
                    else {
                print("data is invalid")
                return nil
            }

            let author = authorOption ?? "" // TODO: should fix it when name is image.
            let dd = Util.dateFromString(dateStr: postTime, format: "yyyy-MM-dd HH:mm:ss")
            let readCount = Int(readCountText.digitsOnly()) ?? 0
            return Article(title: title, author: author, readCount: readCount, content: content, regDate: dd, comments: comments)
        }
        return nil
    }

    func getComment() -> Future<[Comment], NoError> {
        let commentUrl = buildCommentUrl()
        return AlamofireRequestAsJson(commentUrl).map(parseComment)
    }

    func buildCommentUrl() -> String {
        let documentId = self.url.digitsOnly()
        return "https://www.clien.net/service/api/board/park/\(documentId)/comment?param=%7B%22order%22%3A%22date%22%2C%22po%22%3A0%2C%22ps%22%3A999999%7D"
    }

    func parseComment(_ response: DataResponse<Any>) -> [Comment] {
        switch response.result {
        case .success(let JSON):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let response = JSON as! NSArray
            var comments = [Comment]()
            var reCommentSns = [Int:Bool?]()
            for comment in response {
                let commentDic = comment as! NSDictionary

                let content = commentDic["comment"] as! String
                let author = (commentDic["member"] as! NSDictionary!)["nick"] as! String
                let regDate = commentDic["insertDate"] as! String
                let reCommentSn = commentDic["reCommentSn"] as! Int

                let dd = (formatter.date(from: regDate))

                if reCommentSns[reCommentSn] != nil {
                    comments.append(Comment(author: author, content: content, regDate: dd!, depth: 1))
                } else {
                    comments.append(Comment(author: author, content: content, regDate: dd!, depth: 0))
                }
                reCommentSns[reCommentSn] = true
            }

            return comments
        case .failure(_):
            return [Comment]()
        }
    }
}
