//
//  AddLoanView.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 9/28/22.
//

import SwiftUI

struct AddLoanView: View {
    @ObservedObject var viewModel: AddLoanViewModel

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.isShowingAddLoanView.wrappedValue.toggle()
                } label: {
                    Text("Cancel")
                        .font(.title3)
                        .frame(width: 80, height: 40)
                }

                Spacer()
                
                Button {
                    viewModel.saveLoan()
                    viewModel.isShowingAddLoanView.wrappedValue.toggle()
                } label: {
                    Text("Done")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 80, height: 40)
                }
                .disabled(viewModel.isValidForm())
            }
            .padding()

            Form {
                TextField("Name", text: $viewModel.name)
                    .autocapitalization(.sentences)
                TextField("Amount", text: $viewModel.amount)
                    .keyboardType(.numberPad)
                DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                DatePicker("Due Date", selection: $viewModel.dueDate, displayedComponents: .date)
            }
        }
    }
}

//struct AddLoanView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddLoanView(viewModel: <#AddLoanViewModel#>)
//    }
//}
