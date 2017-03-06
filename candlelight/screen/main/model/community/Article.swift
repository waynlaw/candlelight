//
//  Content.swift
//  candlelight
//
//  Created by Lawrence on 2017. 3. 6..
//  Copyright © 2017년 Waynlaw. All rights reserved.

import Foundation

class Article {
    // 제목
    let title: String
    
    // 작성자
    let author: String
    
    // 읽은 수
    let readCount: Int
    
    // 작성일
    let regDate: NSDate
    
    // 댓글
    let comments: List<Comment>
    
}
