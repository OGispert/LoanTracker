//
//  AddPaymentViewModel.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 10/4/22.
//

import Foundation

final class AddPaymentViewModel: ObservableObject {

    @Published var amount = ""
    @Published var date = Date()

    var loanId: String

    init(loanId: String) {
        self.loanId = loanId
    }

    func createNewPayment() {
        let newPayment =  Payment(context: PersistenceController.shared.context)
        newPayment.id = UUID().uuidString
        newPayment.amount = Double(amount) ?? 0.0
        newPayment.date = date
        newPayment.loanId = loanId

        PersistenceController.shared.saveContext()
    }

    func isFormValid() -> Bool {
        !amount.isEmpty
    }
}
