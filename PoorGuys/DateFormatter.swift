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
}
