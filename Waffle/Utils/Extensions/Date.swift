//
//  Date.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

extension Date {
    
    func addArchiveDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: self)
    }
}
