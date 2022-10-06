//
//  Persistence.swift
//  LoanTracker
//
//  Created by Othmar Gispert on 9/27/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "LoanTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error: Context was not saved - ", error.localizedDescription)
        }
    }

    func fetchPayments(for loanId: String) -> [Payment] {
        let fetchRequest: NSFetchRequest<Payment> = Payment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "loanId == %@", loanId)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Payment.date, ascending: true)]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error: Context was not fecth - ", error.localizedDescription)
            return []
        }
    }
}
