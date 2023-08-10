//
//  DateFormatter.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import Foundation

extension DateFormatter {
    func excludeYear(from date: Date) -> String {
        self.dateFormat = "MM/dd HH:mm"
        
        return self.string(from: date)
    }
    
    func toKorean(from date: Date) -> String {
        locale = Locale(identifier: "ko_KR")
        dateFormat = "MM월 dd일 (E)"
        
        return self.string(from: date)
    }
    
    func toKoreanIncludingYear(from date: Date) -> String {
        locale = Locale(identifier: "ko_KR")
        dateFormat = "YYYY년 MM월 dd일"
        
        return self.string(from: date)
    }
}
