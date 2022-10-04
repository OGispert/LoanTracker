//
//  Couble+Extension.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 9/27/22.
//

import Foundation

extension Double {
    var toCurrency: String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currency
        formatter.locale = Locale.current

        return formatter.string(from: NSNumber(value: self)) ?? "Unknown"
    }
}
