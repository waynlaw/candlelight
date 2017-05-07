//
//  PpomppuArticleCrawler.swift
//  candlelight
//
//  Created by Lawrence on 2017. 5. 5..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class PpomppuArticleCrawler: ArticleCrawler {
    
    let url: String
    
    init(_ url: String) {
        self.url = url
    }
    
    func getContent() -> Future<Article?, NoError>{
        return AlamofireRequestWithoutEncoding(url).map(parseHTML)
    }
    
    func parseHTML(html: String) -> Article? {
        if let doc = HTML(html: html, encoding: .utf8) {
            
            let titleOption = doc.xpath("//font[contains(@class, 'view_title2')]").first?.text
            
            
            let infoOption = doc.xpath("//table[contains(@class, 'info_bg')]//table").first?.xpath("//td[5]").first?.text
            
//            let authorOption = doc.xpath("//font[contains(@class, 'view_name')]").first?.text
            
//            let readCountOption = doc.xpath("//span[contains(@class, 'read')]").first?.text
            
            // ok
            let contentOption = doc.xpath("//td[contains(@class, 'board-contents')]").first?.innerHTML
            
            let commentsOption = doc.xpath("//div[@id='quote']//table")
            
//            let regDateOption = doc.xpath("//div[contains(@class, 'read_header')]//p[contains(@class, 'time')]").first?.text
            
            guard let title = titleOption,
                  let content = contentOption,
                  let info = infoOption
                  else {
                    print("data is invalid")
                    return nil
            }

            let author = info.components(separatedBy: ":")[1].components(separatedBy: "\n")[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let readCount = info.components(separatedBy: ":")[4].components(separatedBy: "\n")[0].components(separatedBy: "/")[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let regDate = Util.matches(for: "\\d+-\\d+-\\d+\\s\\d+:\\d+", in: info).first!
            
            let dd = Util.dateFromString(dateStr: regDate, format: "yyyy-MM-dd HH:mm")
            
            let comments = commentsOption.map({(c) -> HTMLDocument in
                HTML(html: c.toHTML!, encoding: .utf8)!
            }).map({ (cts) -> Comment in
                
                // TODO : You have to refactoring :-)
                let maybe = cts.xpath("//td[5]//b").first
                
                if let _ = maybe {
                    Comment()
                } else {
                    return Comment(author: author, content: content, regDate: dd, depth: 0)
                }

                let author = (cts.xpath("//td[5]//b").first?.text)!
                let content = (cts.xpath("//td[5]//div[1]").first?.text)!
                let regDate = (cts.xpath("//td[6]//font").first?.text)!
                
//                let regDate = (cts.xpath("//p[contains(@class, 'time')]").first?.text)!
//                
                let dd = Util.dateFromString(dateStr: regDate, format: "yyyy-MM-ddHH:mm:ss")
//
//                let className = (cts.xpath("//div").first?.className)!
//                
//                var depth = 0
//                if className.contains("indent") {
//                    depth = Int(className.substring(from: className.index(className.endIndex, offsetBy: -1)))!
//                }
//                
//                let content = (cts.xpath("//div[contains(@class, 'xe_content')]").first?.text)!
//
                return Comment(author: author, content: content, regDate: dd, depth: 0)
                
//                return Comment()
            })
            
            return Article(title: title, author: author, readCount: Int(readCount)!,content: content, regDate:dd, comments: comments)
        }
        return nil
    }
}
