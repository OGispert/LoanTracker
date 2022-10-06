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
    @Published var payment: Payment?

    var loanId: String

    init(paymentToEdit payment: Payment?, loanId: String) {
        self.payment = payment
        self.loanId = loanId
    }

    func savePayment() {
        guard let payment = payment else {
            self.createNewPayment()
            return
        }
        updatePayment(payment)
    }

    func createNewPayment() {
        let newPayment =  Payment(context: PersistenceController.shared.context)
        newPayment.id = UUID().uuidString
        newPayment.amount = Double(amount) ?? 0.0
        newPayment.date = date
        newPayment.loanId = loanId

        PersistenceController.shared.saveContext()
    }

    func updatePayment(_ payment: Payment) {
        payment.amount = Double(amount) ?? 0.0
        payment.date = date

        PersistenceController.shared.saveContext()
    }

    func isFormValid() -> Bool {
        !amount.isEmpty
    }

    func setupEditingView() {
        guard let payment = payment else { return }
        amount = "\(payment.amount)"
        date = payment.date ?? Date()
    }
}
