//
//  PaymentCellView.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 10/4/22.
//

import SwiftUI

struct PaymentCellView: View {
    let amount: Double
    let date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(amount.toCurrency)
                .font(.title2)
                .fontWeight(.semibold)

            Text(date.longDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct PaymentCellView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCellView(amount: 200.0, date: Date())
    }
}
