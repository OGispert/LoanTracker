//
//  LoanCellView.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 9/27/22.
//

import SwiftUI

struct LoanCellView: View {
    let name: String
    let amount: Double
    let date: Date

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(amount.toCurrency)
                    .font(.title2)
                    .fontWeight(.light)
            }

            Spacer()

            Text(date.longDate)
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

struct LoanCellView_Previews: PreviewProvider {
    static var previews: some View {
        LoanCellView(name: "loan", amount: 1000, date: Date())
    }
}
