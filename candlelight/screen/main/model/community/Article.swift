//
//  Content.swift
//  candlelight
//
//  Created by Lawrence on 2017. 3. 6..
//  Copyright © 2017년 Waynlaw. All rights reserved.

import Foundation

class Article {
    // 제목
    var title: String?
    
    // 작성자
    var author: String?
    
    // 읽은 수
    var readCount: Int?
    
    // 작성일
    var regDate: NSDate?
    
    // 댓글
    var comments: [Comment]?
    
    public init(){
    }
}
