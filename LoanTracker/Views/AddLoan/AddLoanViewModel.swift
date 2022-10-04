//
//  AddLoanViewModel.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 9/28/22.
//

import Foundation
import SwiftUI

final class AddLoanViewModel: ObservableObject {
    @Published var name = ""
    @Published var amount = ""
    @Published var startDate = Date()
    @Published var dueDate = Date()

    var isShowingAddLoanView: Binding<Bool>

    init(isShowingAddLoanView: Binding<Bool>) {
        self.isShowingAddLoanView = isShowingAddLoanView
    }

    func saveLoan() {
        let newLoan = Loan(context: PersistenceController.shared.context)
        newLoan.id = UUID().uuidString
        newLoan.name = name
        newLoan.totalAmount = Double(amount) ?? 0.0
        newLoan.startDate = startDate
        newLoan.dueDate = dueDate

        PersistenceController.shared.saveContext()
    }

    func isValidForm() -> Bool {
        !name.isEmpty && !amount.isEmpty
    }
}
