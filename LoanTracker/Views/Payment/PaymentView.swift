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

            Text("Expected to finish")

            List {
                ForEach(viewModel.allPayments) { payment in
                    Text(payment.amount.toCurrency)
                }
            }
            .listStyle(.plain)
        }
        .onAppear(perform: {
            viewModel.fetchAllPayments()
        })
        .navigationTitle("\(viewModel.loan.name ?? "")")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("add payment")
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
            }
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(viewModel: PaymentViewModel(loan: Loan()))
    }
}
