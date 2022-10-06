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

            ProgressBar(value: viewModel.progressBarValue(),
                        leftAmount: viewModel.totalDue(),
                        paidAmount: viewModel.totalPaid())
                .frame(height: 30)
                .padding(.horizontal)

            Text(viewModel.expectedToFinishOn)
                .foregroundColor(viewModel.expectedLabelColor)

            List {
                ForEach(viewModel.allPaymentObjects, id: \.sectionName) { paymentObj in
                    Section {
                        ForEach(paymentObj.sectionObject) { payment in
                            PaymentCellView(amount: payment.amount,
                                            date: payment.date ?? Date())
                                .onTapGesture {
                                    viewModel.isNavigationLinkActive = true
                                    viewModel.selectedPayment = payment
                                }
                        }
                        .onDelete { index in
                            viewModel.deletePayment(paymentObj, at: index)
                        }
                    } header: {
                        Text("\(paymentObj.sectionName) - \(paymentObj.sectionTotal.toCurrency)")
                    }
                }
            }
            .listStyle(.plain)
        }
        .onAppear(perform: {
            viewModel.selectedPayment = nil
            viewModel.fetchAllPayments()
            viewModel.calculateDaysToEnd()
            viewModel.separateByYear()
        })
        .navigationTitle(viewModel.loan.name ?? "Loan")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.isNavigationLinkActive.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
            }
        }
        NavigationLink(isActive: $viewModel.isNavigationLinkActive) {
            AddPaymentView(viewModel: AddPaymentViewModel(paymentToEdit: viewModel.selectedPayment, loanId: viewModel.loan.id ?? ""))
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
