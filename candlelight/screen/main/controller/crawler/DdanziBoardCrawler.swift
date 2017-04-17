import Foundation
import BrightFutures
import enum Result.Result
import enum Result.NoError
import Alamofire
import Kanna

class DdanziBoardCrawler: BoardCrawler {
    
    let siteUrl = "http://www.ddanzi.com/index.php?mid=free&page="
    
    func getList(page: Int) -> Future<[ListItem]?, NoError> {
        return Future<[ListItem]?, NoError> { complete in
            let url = self.siteUrl + String(page + 1)
            
            // TODO: 일단 일주일 사이 무사히 통과함
            
            let headers = [
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
                "Cookie": "cf_clearance=b675b2b14544cb66477d3cd01b1e152922388c3a-1490010629-86400; __cfduid=d954df114e6868384c1fae97adfa232e41490010661; PHPSESSID=s8m7bsfshh1f3ubc7j486169t7; mobile=false; user-agent=cc5d8203ce9b96784a0bea9c5a67de54; TS015721a6=019b04a842b86c12947c0d3bffc315236029a6014671550088d231380c4630c5f5b1758f9c241f8b91f7f0adfff3d6b666431db32bb174a5c36c8a573d4a09dbca8031285b01af82da6cfa871c7654f372812feeae; _ga=GA1.2.1895096741.1490010661"
            ]
            
            Alamofire.request(url, headers: headers).responseString(encoding: .utf8, completionHandler: { response in
                if let html = response.result.value {
                    complete(self.parseHTML(html: html))
                } else {
                    complete(.success(nil))
                }
            })
        }
    }
    
    func parseHTML(html: String) -> Result<Array<ListItem>?, NoError> {
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
                let titleOption = content.xpath("td[2]//a").map{v in v.text!}.joined(separator: " ")
                let pageIdOption = content.xpath("td[1]").first?.text.flatMap{v in Int(v.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))}
                let urlOption = content.xpath("td[2]//a").first?["href"]
                let authorOption = content.xpath("td[3]//a").first?.text
                let readCountOption = content.xpath("td[5]").first?.text.flatMap{v in Int(v)}
                
                guard let pageId = pageIdOption,
//                    let title = titleOption,
                    let url = urlOption,
                    let author = authorOption,
                    let readCount = readCountOption else {
                        continue
                }
                result.append(ListItem(id: pageId, title: titleOption, url: url, author: author, date: "", readCount: readCount))
            }
        }
        return .success(result)
    }
}
