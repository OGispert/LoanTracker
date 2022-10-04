//
//  LoansView.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 9/27/22.
//

import SwiftUI
import CoreData

struct LoansView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Loan.dueDate, ascending: true)],
        animation: .default)
    private var loans: FetchedResults<Loan>

    @State var isShowingAddLoanView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(loans) { loan in
                    let paymentViewModel = PaymentView(viewModel: PaymentViewModel(loan: loan))
                    NavigationLink(destination: paymentViewModel) {
                        LoanCellView(name: loan.name ?? "Unknown",
                                     amount: loan.totalAmount,
                                     date: loan.dueDate ?? Date())
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .navigationTitle("All Loans")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddLoanView.toggle()
                    } label: {
                        Text("Add Loan")
                    }
                    .sheet(isPresented: $isShowingAddLoanView) {
                        let viewModel = AddLoanViewModel(isShowingAddLoanView: $isShowingAddLoanView)
                        AddLoanView(viewModel: viewModel)
                    }
                }
            }
        }
        .accentColor(Color(.label))
    }

    private func addItem() {
        withAnimation {
            let newLoan = Loan(context: viewContext)
            newLoan.name = "new loan"
            newLoan.startDate = Date()
            newLoan.dueDate = Date()
            newLoan.totalAmount = 1000

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { loans[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoansView()
    }
}
