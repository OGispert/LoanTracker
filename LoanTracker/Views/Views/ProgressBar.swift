//
//  ProgressBar.swift
//  LoanTracker
//
//  Created by ogisq on 10/5/22.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double
    var leftAmount: Double
    var paidAmount: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(.teal)

                    Text(leftAmount.toCurrency)
                        .font(.caption)
                        .padding(.horizontal)
                }
                .cornerRadius(45)

                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: min(CGFloat(self.value)*geometry.size.width,
                                          geometry.size.width),
                               height: geometry.size.height)
                        .opacity(0.5)
                        .foregroundColor(.blue)

                    Text(paidAmount.toCurrency)
                        .font(.caption)
                        .padding(.horizontal)
                }
                .cornerRadius(45)
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: 0.5, leftAmount: 300, paidAmount: 300)
    }
}
