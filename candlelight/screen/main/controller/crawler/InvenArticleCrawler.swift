//
//  InvenArticleCrawler.swift
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

class InvenArticleCrawler: ArticleCrawler {
    
    let url: String
    
    init(_ url: String) {
        self.url = url
    }
    
    func getContent() -> Future<Article?, NoError>{
        return Future<Article?, NoError> { complete in
            return Future<[BoardItem]?, NoError> { complete in
                // TODO
                complete(.success(nil))
            }
        }
    }
}
