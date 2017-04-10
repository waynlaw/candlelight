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
    var regDate: Date?

    // 댓글
    var comments: [Comment]?

    public init() {
    }

    public init(title: String, author: String, readCount: Int, content: String, regDate: Date, comments: [Comment]) {
        self.title = title
        self.author = author
        self.readCount = readCount
        self.content = content
        self.regDate = regDate
        self.comments = comments
    }

    func toHtml() -> String {
        do {
            let filepath = Bundle.main.path(forResource: "template", ofType: "html", inDirectory: "")
            let contents = try String(contentsOfFile: filepath!)

            // Optional guard
            guard let _ = title,
                  let _ = author,
                  let _ = regDate,
                  let _ = readCount,
                  let _ = content,
                  let _ = comments else {
                return ""
            }

            let coms = comments!.map({ (c) -> String in
                c.toHtml()
            }).reduce("", { $0 + $1 })

            let contentHtml = contents.replacingOccurrences(of: "{{title}}", with: self.title!)
                    .replacingOccurrences(of: "{{author}}", with: self.author!)
                    .replacingOccurrences(of: "{{regDate}}", with: dateToString(self.regDate!))
                    .replacingOccurrences(of: "{{readCount}}", with: self.readCount!.description)
                    .replacingOccurrences(of: "{{content}}", with: self.content!)
                    .replacingOccurrences(of: "{{comments}}", with: coms)

            return contentHtml

        } catch {
        }
        return ""
    }

    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        return formatter.string(from: date)
    }
/*
            <div class='depth1'>
                <p>
                    <span class='author'>{{author}}</span>
                    <span class='reg-date'>{{regDate}}</span>
                </p>
                <span class='comment'>
                    {{comment}}
                </span>
            </div>
            <div class='depth2'>
                <p>
                    <span class='author'>{{author}}</span>
                    <span class='reg-date'>{{regDate}}</span>
                </p>
                <span class='comment'>
                    {{comment}}
                </span>
            </div>
            <div class='depth3'>
                <p>
                    <span class='author'>{{author}}</span>
                    <span class='reg-date'>{{regDate}}</span>
                </p>
                <span class='comment'>
                    {{comment}}
                </span>
            </div>
*/

}
