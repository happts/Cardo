//
//  FoundationExtension.swift
//  Cardo
//
//  Created by happts on 2019/3/24.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
// 标准时间格式转换
extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
    
    static let myFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var myDateString :String {
        get {
            return Date.myFormatter.string(from: self)
        }
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
    
    var dateFromMyFormat: Date? {
        return Date.myFormatter.date(from: self)
    }
}
