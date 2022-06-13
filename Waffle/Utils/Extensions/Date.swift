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
    
    func addArchiveDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: self)
    }
    
    func addArhiveTimeToString() -> String {
        let timeFormatter = DateFormatter()
        //timeFormatter.locale = Locale(identifier: ")
        timeFormatter.dateFormat = "a hh시 mm분"
        timeFormatter.amSymbol = "오전"
        timeFormatter.pmSymbol = "오후"
        return timeFormatter.string(from: self)
    }
    
    func getWeekDay() -> String {
//        let calendar = Calendar(identifier: .gregorian)
//        return WeekDayString(rawValue: calendar.dateComponents([.weekday], from: self).weekday ?? 0)! + "요일"
        return ""
    }
}
