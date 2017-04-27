//
//  Util.swift
//  candlelight
//
//  Created by Lawrence on 2017. 4. 27..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import Foundation

class Util {
    class func dateFromString(dateStr: String, format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let dd = (formatter.date(from: dateStr)) {
            return dd
        } else {
            return Date()
        }
    }
    
    class func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
