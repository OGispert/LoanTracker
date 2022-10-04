//
//  Date+Extension.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 9/27/22.
//

import Foundation

extension Date {
    var yearNumber: Int? {
        Calendar.current.dateComponents([.year], from: self).year
    }

    var longDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM. dd, yyyy"
        return formatter.string(from: self)
    }
}
