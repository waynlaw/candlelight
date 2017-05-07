//
//  PpomppuBoardCrawler.swift
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

class PpomppuBoardCrawler: BoardCrawler {
    
    let siteUrl = "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page="
    let contentsBaseUrl = "http://www.ppomppu.co.kr/zboard/"
    
    func getList(page: Int) -> Future<[BoardItem]?, NoError> {
        return Future<[BoardItem]?, NoError> { complete in
            let url = self.siteUrl + String(page + 1)
            Alamofire.request(url).responseString(completionHandler: { response in
                
//                let responseString = NSString(data: data, encoding:
//                    CFStringConvertEncodingToNSStringEncoding( 0x0422 ) )
//                
//                println(" Response Data is = \(responseString)")
                if let html = response.result.value {
                    complete(self.parseHTML(html: html))
                } else {
                    complete(.success(nil))
                }
            })
        }
    }
    
    func parseHTML(html: String) -> Result<Array<BoardItem>?, NoError> {
        var result = [BoardItem]()
        if let doc = HTML(html: html, encoding: .utf8) {
            for content in doc.xpath("//table[@id='revolution_main_table']//tr") {
                
                let titleOption = content.xpath("td[3]//a").first?.text
                let pageIdOption = content.xpath("td[1]").first?.text.flatMap{v in Int(v)}
                let urlOption = content.xpath("td[3]//a").first?["href"]
                let authorOption = content.xpath("td[2]//span").first?.text
                let readCountOption = content.xpath("td[6]").first?.text.flatMap{v in Int(v)}
                let commentCountOptions = content.xpath("td[3]//span").first?.text
                guard let pageId = pageIdOption,
                      let title = titleOption,
                      let url = urlOption,
                      let author = authorOption,
                      let readCount = readCountOption else {
                        continue
                }
                
                let contentsUrl = contentsBaseUrl + url
                if let commentCount = commentCountOptions {
                    result.append(BoardItem(id: pageId, title: title + " [" + commentCount + "]", url: contentsUrl, author: author, date: "", readCount: readCount))
                } else {
                    result.append(BoardItem(id: pageId, title: title, url: contentsUrl, author: author, date: "", readCount: readCount))
                }
            }
        }
        return .success(result)
    }
}
