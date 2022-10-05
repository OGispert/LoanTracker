//
//  PaymentView.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 10/3/22.
//

import SwiftUI

struct PaymentView: View {

    @ObservedObject var viewModel: PaymentViewModel

    var body: some View {
        VStack {
            Text("Payment Progress")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top)

            Rectangle()
                .frame(height: 30)
                .foregroundColor(.blue)
                .cornerRadius(10)
                .padding()

            Text(viewModel.expectedToFinishOn)

            List {
                ForEach(viewModel.allPaymentObjects, id: \.sectionName) { object in
                    Section {
                        ForEach(object.sectionObject) { payment in
                            PaymentCellView(amount: payment.amount,
                                            date: payment.date ?? Date())
                        }
                        .onDelete { index in
                            viewModel.deletePayment(at: index)
                        }
                    } header: {
                        Text("\(object.sectionName) - \(object.sectionTotal.toCurrency)")
                    }
                }
            }
            .listStyle(.plain)
        }
        .onAppear(perform: {
            viewModel.fetchAllPayments()
            viewModel.calculateDaysToEnd()
            viewModel.separateByYear()
        })
        .navigationTitle(viewModel.loan.name ?? "Loan")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.isNaviagtionLinkActive.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
            }
        }
        NavigationLink(isActive: $viewModel.isNaviagtionLinkActive) {
            AddPaymentView(viewModel: AddPaymentViewModel(loanId: viewModel.loan.id ?? ""))
        } label: {
            Text("")
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(viewModel: PaymentViewModel(loan: Loan()))
    }
}
