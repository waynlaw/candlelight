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
    
    // 읽은 수
    var content: String?
    
    // 작성일
    var regDate: NSDate?
    
    // 댓글
    var comments: [Comment]?
    
    public init(){
    }
    
    public init(title: String, author: String, readCount: Int, content: String, regDate: NSDate, comments: [Comment]){
        self.title = title
        self.author = author
        self.readCount = readCount
        self.content = content
        self.regDate = regDate
        self.comments = comments
        
    }
}
