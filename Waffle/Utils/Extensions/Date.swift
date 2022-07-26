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
    
    func beforeDayText(time: String) -> String   //2022-07월-19 00:31:10
    {
        let todayString = "오늘"
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM월-dd hh:mm:ss"
        guard let timeDate = dateFormatter.date(from: time) else { return todayString }
        guard let distanceDay = Calendar.current.dateComponents([.day], from: timeDate, to: date).day else { return todayString }
        if distanceDay == 0 {
            return todayString
        }else {
            return "\(distanceDay)일 전"
        }
    }
    
    func detailDateString(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let parsingFormatter = DateFormatter()
        parsingFormatter.dateFormat = "MM월 dd일"
        guard let dateString = dateFormatter.date(from: date) else { return "" }
        return parsingFormatter.string(from: dateString)
    }
}
