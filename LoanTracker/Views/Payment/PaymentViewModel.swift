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
    @Published var isNaviagtionLinkActive = false
    @Published var expectedToFinishOn = ""

    var loan: Loan

    init(loan: Loan) {
        self.loan = loan
    }

    func fetchAllPayments() {
        allPayments = PersistenceController.shared.fetchPayments(for: loan.id ?? "")
    }

    func deletePayment(at index: IndexSet) {
        guard let indexRow = index.first else { return }
        PersistenceController.shared.context.delete(allPayments[indexRow])
        PersistenceController.shared.saveContext()
    }

    func totalPaid() -> Double {
        return allPayments.reduce(0, { $0 + $1.amount })
    }

    func calculateDaysToEnd() {
        let totalAmountPaid = totalPaid()
        let totalPassedDays = Calendar.current.dateComponents([.day],
                                                              from: loan.startDate ?? Date(),
                                                              to: Date()).day

        if totalPassedDays == 0 || totalAmountPaid == 0 {
            expectedToFinishOn = ""
            return
        }

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
    }

    func separateByYear() {
        allPaymentObjects = []

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
