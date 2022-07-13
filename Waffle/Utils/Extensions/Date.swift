//
//  Date.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

enum WeekDayString: Int {
    case 일 = 1, 월, 화, 수, 목, 금, 토
}

extension Date {
    func sendDataFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func sendTimeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func addArchiveDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        return dateFormatter.string(from: self)
    }
    
    func addArhiveTimeToString() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "a h시 m분"
        timeFormatter.amSymbol = "오전"
        timeFormatter.pmSymbol = "오후"
        return timeFormatter.string(from: self)
    }

}
