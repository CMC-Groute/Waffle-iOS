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
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: self)
    }
    
    func addArhiveTimeToString() -> String {
        let timeFormatter = DateFormatter()
        //timeFormatter.locale = Locale(identifier: ")
        timeFormatter.dateFormat = "a h시 m분"
        timeFormatter.amSymbol = "오전"
        timeFormatter.pmSymbol = "오후"
        return timeFormatter.string(from: self)
    }
    
    func getWeekDay() -> String {
//        let calendar = Calendar(identifier: .gregorian)
//        return WeekDayString(rawValue: calendar.dateComponents([.weekday], from: self).weekday ?? 0)! + "요일"
        return ""
    }
    
    static func getDate(dateString: String) -> [String] {
//        let dateComponent = dateString.components(separatedBy: "T")
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "HH:mm:ss"
//
//        let date = dateFormatter.date(from: dateComponent[0])
//        let time = timeFormatter.date(from: dateComponent[1])
//
//        return [date!.addArchiveDateToString(), time!.addArhiveTimeToString()]
        return []
    }

}
