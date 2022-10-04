//
//  PaymentViewModel.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 10/3/22.
//

import SwiftUI

final class PaymentViewModel: ObservableObject {

    @Published var allPayments: [Payment] = []

    var loan: Loan

    init(loan: Loan) {
        self.loan = loan
    }

    func fetchAllPayments() {
        allPayments = PersistenceController.shared.fetchPayments(for: loan.id ?? "")
    }
}
