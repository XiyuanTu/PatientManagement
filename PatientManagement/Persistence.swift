//
//  Persistence.swift
//  PatientManagement
//
//  Created by xiyuan tu on 4/7/24.
//

import CoreData
import Foundation

class PersistenceController {
    static let shared = PersistenceController()
    
    let modelName = "PatientManager"
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        let modelURL = Bundle(for: type(of: self)).url(forResource: modelName, withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        
        container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
//                print(storeDescription.url!)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
