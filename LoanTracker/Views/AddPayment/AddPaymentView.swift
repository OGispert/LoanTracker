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
                    viewModel.createNewPayment()
                    dismiss()
                } label: {
                    Text("Save")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .disabled(!viewModel.isFormValid())
        }
        .navigationTitle("Add Payment")
    }
}

struct AddPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentView(viewModel: AddPaymentViewModel(loanId: "123"))
    }
}
