//
//  WappleLog.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/05.
//

import Foundation

final public class WappleLog {
    
    public class func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
            let output = items.map { "\($0)" }.joined(separator: separator)
            print("🗣 [\(getCurrentTime())] Wapple - \(output)", terminator: terminator)
        #else
            print("🗣 [\(getCurrentTime())] Wapple - RELEASE MODE")
        #endif
    }
    
    public class func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
            let output = items.map { "\($0)" }.joined(separator: separator)
            print("⚡️ [\(getCurrentTime())] Wapple - \(output)", terminator: terminator)
        #else
            print("⚡️ [\(getCurrentTime())] Wapple - RELEASE MODE")
        #endif
    }
    
    public class func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
            let output = items.map { "\($0)" }.joined(separator: separator)
            print("🚨 [\(getCurrentTime())] Wapple - \(output)", terminator: terminator)
        #else
            print("🚨 [\(getCurrentTime())] Wapple - RELEASE MODE")
        #endif
    }
    
    fileprivate class func getCurrentTime() -> String {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: now as Date)
    }
}
