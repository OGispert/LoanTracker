//
//  AddPaymentView.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 10/4/22.
//

import SwiftUI

struct AddPaymentView: View {

    @ObservedObject var viewModel: AddPaymentViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                TextField("Amount", text: $viewModel.amount)
                    .keyboardType(.numberPad)

                DatePicker("Date", selection: $viewModel.date)
            }

            Section {
                Button {
                    viewModel.savePayment()
                    dismiss()
                } label: {
                    Text("Save")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .disabled(!viewModel.isFormValid())
        }
        .onAppear(perform: {
            viewModel.setupEditingView()
        })
        .navigationTitle(viewModel.payment != nil ? "Edit Payment" : "Add Payment")
    }
}

struct AddPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentView(viewModel: AddPaymentViewModel(paymentToEdit: nil, loanId: "123"))
    }
}
