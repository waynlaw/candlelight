import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class DdanziCrawler: ListCrawler {
    
    let siteUrl = "http://www.ddanzi.com/index.php?mid=free&page="
    
    func getList() -> Future<[ListItem], NoError> {
        return result(page: 0)
    }
    
    func getList(page: Int) -> Future<[ListItem], NoError> {
        return result(page: page)
    }
    
    func result(page: Int) -> Future<[ListItem], NoError> {
        return Future<[ListItem], NoError> { complete in
            let url = self.siteUrl + String(page + 1)
            print(url)
            Alamofire.request(url).responseString(encoding: .utf8, completionHandler: { response in
                if let html = response.result.value {
                    complete(self.parseHTML(html: html))
                }
            })
        }
    }
    
    func parseHTML(html: String) -> Result<Array<ListItem>, NoError> {
/*
 <tr>
 <td class="no">3366070</td>
 <td class="title"><a href="http://www.ddanzi.com/index.php?mid=free&amp;page=1&amp;document_srl=164077918">93학번 딴게이 모여라!!!!<img src="http://www.ddanzi.com/modules/document/tpl/icons/jage_file.gif" alt="file" title="file" style="margin-right:2px;" /></a>
 </td>
 <td class="author">
   <div class="bh_author">
     <a href="#popup_menu_area" class="member_6409536" onclick="return false">고랑포결사대</a>
   </div>
 </td>
 <td class="time">21:54:22</td>
 <td class="readNum">2</td>
 <td class="voteNum">-</td>
 </tr>
 */
        var result = [ListItem]()
        
        if let doc = HTML(html: html, encoding: .utf8) {
            for content in doc.xpath("//table//tbody//tr") {
                let titleOption = content.xpath("td[2]//a").first?.text
                let pageIdOption = content.xpath("td[1]").first?.text.flatMap{v in Int(v.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))}
                let urlOption = content.xpath("td[2]//a").first?["href"]
                let authorOption = content.xpath("td[3]//a").first?.text
                let readCountOption = content.xpath("td[5]").first?.text.flatMap{v in Int(v)}
                
                guard let pageId = pageIdOption,
                    let title = titleOption,
                    let url = urlOption,
                    let author = authorOption,
                    let readCount = readCountOption else {
                        continue
                }
                result.append(ListItem(id: pageId, title: title, url: url, author: author, date: "", readCount: readCount))
            }
        }
        return .success(result)
    }
}
