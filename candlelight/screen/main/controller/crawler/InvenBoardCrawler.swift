//
//  InvenBoardCrawler.swift
//  candlelight
//
//  Created by Lawrence on 2017. 5. 15..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class InvenBoardCrawler: BoardCrawler {
    
    let siteUrl = "http://www.inven.co.kr/board/powerbbs.php?come_idx=2097&iskin=webzine&p="
    let contentsBaseUrl = "http://www.inven.co.kr/board/powerbbs.php?come_idx=2097&p=3&iskin=webzine&l="
    
    func getList(page: Int) -> Future<[BoardItem]?, NoError> {
        let url = self.siteUrl + String(page + 1)
        return AlamofireRequest(url).map(parseHTML)
    }
    
    func parseHTML(html: String) -> [BoardItem]? {
        guard let doc = HTML(html: html, encoding: .utf8) else {
            return nil
        }
        var result = [BoardItem]()
        for content in doc.xpath("//form[contains(@name, 'board_list1')]//table//tr") {
            
            let pageIdOption = content.xpath("td[1]//a").first?["data-uid"].flatMap{v in Int(v)}
            let titleOption = content.xpath("td[2]//a").first?.text
            let urlOption = content.xpath("td[2]//a").first?["href"]
            let authorOption = content.xpath("td[3]//span").first?.text
            let dateOption = content.xpath("td[4]").first?.text
            let readCountOption = content.xpath("td[5]").first?.text.flatMap{v in Int(v)}

            guard let pageId = pageIdOption,
                let title = titleOption,
                let url = urlOption,
                let author = authorOption,
                let date = dateOption,
                let readCount = readCountOption else {
                continue
            }

            result.append(BoardItem(id: pageId, title: title, url: url, author: author, date: date, readCount: readCount))
            
        }
        return result
    }

}
