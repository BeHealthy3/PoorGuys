//
//  Date+Extensions.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/08/03.
//

import Foundation

extension Date {
    func dotted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: self)
    }
}
