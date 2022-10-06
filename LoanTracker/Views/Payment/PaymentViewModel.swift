//
//  PaymentViewModel.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 10/3/22.
//

import SwiftUI

final class PaymentViewModel: ObservableObject {

    @Published var allPayments: [Payment] = []
    @Published var allPaymentObjects: [PaymentObject] = []
    @Published var isNavigationLinkActive = false
    @Published var expectedToFinishOn = ""
    @Published var selectedPayment: Payment?
    @Published var expectedLabelColor: Color = .primary

    var loan: Loan

    init(loan: Loan) {
        self.loan = loan
    }

    func fetchAllPayments() {
        allPayments = PersistenceController.shared.fetchPayments(for: loan.id ?? "")
    }

    func deletePayment(_ paymentObject: PaymentObject, at index: IndexSet) {
        guard let indexRow = index.first else { return }
        let paymentToDelete = paymentObject.sectionObject[indexRow]
        PersistenceController.shared.context.delete(paymentToDelete)
        PersistenceController.shared.saveContext()

        fetchAllPayments()
        calculateDaysToEnd()
        separateByYear()
    }

    func totalPaid() -> Double {
        allPayments.reduce(0, { $0 + $1.amount })
    }

    func totalDue() -> Double {
        loan.totalAmount - totalPaid()
    }

    func progressBarValue() -> Double {
        totalPaid() / loan.totalAmount
    }

    func calculateDaysToEnd() {
        let totalAmountPaid = totalPaid()
        let totalPassedDays = Calendar.current.dateComponents([.day],
                                                              from: loan.startDate ?? Date(),
                                                              to: Date()).day

        if totalAmountPaid == 0 {
            expectedToFinishOn = ""
            return
        }

        if totalAmountPaid == loan.totalAmount {
            expectedToFinishOn = "Congratulations!! Your Loan was paid."
            expectedLabelColor = .green
            return
        }

        // TODO - Fix prediction logic 
        let didPayPerDay = totalAmountPaid / Double(totalPassedDays ?? 0)
        let daysLeftToFinish = (loan.totalAmount - totalAmountPaid) / didPayPerDay
        let newDate = Calendar.current.date(byAdding: .day,
                                            value: Int(daysLeftToFinish),
                                            to: Date())

        guard let newDate = newDate else {
            expectedToFinishOn = ""
            return
        }
        expectedToFinishOn = "Expected to finish by \(newDate.longDate)"

        expectedLabelColor = newDate > (loan.dueDate ?? Date()) ? .red : .primary
    }

    func separateByYear() {
        allPaymentObjects = []

        allPayments.sort(by: { ($0.date ?? Date()) > ($1.date ?? Date()) })

        let dict = Dictionary(grouping: allPayments, by: { $0.date?.yearNumber })

        for (key, value) in dict {
            var total = 0.0

            value.forEach { payment in
                total += payment.amount
            }

            allPaymentObjects.append(PaymentObject(sectionName: "\(key ?? 0)",
                                                   sectionObject: value,
                                                   sectionTotal: total))
            allPaymentObjects = allPaymentObjects.sorted(by: { $0.sectionName > $1.sectionName })
        }
    }
}


struct PaymentObject: Equatable {
    var sectionName: String!
    var sectionObject: [Payment]!
    var sectionTotal: Double!
}
