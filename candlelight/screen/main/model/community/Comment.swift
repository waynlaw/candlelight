//
//  Comment.swift
//  candlelight
//
//  Created by Lawrence on 2017. 3. 6..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation

class Comment{
    // 댓글
    var content: String?
   
    // 작성자
    var author: String?
    
    // 작성일
    var regDate: NSDate?
    
    // 댓글 깊이
    var depth: Int?
    
    public init(){}
}
