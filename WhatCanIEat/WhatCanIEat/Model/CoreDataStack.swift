//
//  CoreDataStack.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    // MARK: - Properties
    
    private let modelName: String
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Initializer
    
    public init(named name: String) {
        self.modelName = name
    }

    // MARK: - Method
    
    public func saveContext() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}