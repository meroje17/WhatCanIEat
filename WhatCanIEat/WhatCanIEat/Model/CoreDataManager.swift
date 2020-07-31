//
//  CoreDataManager.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    private let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()

    var recipes: [RecipeEntity] {
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }
    
    // MARK: - Initializer
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }
    
    // MARK: - Methods
    
    func createFavoriteRecipe(with recipe: Recipe) {
        let recipeEntity = RecipeEntity(context: managedObjectContext)
        recipeEntity.name = recipe.name
        recipeEntity.image = recipe.image
        recipeEntity.url = recipe.url
        recipeEntity.ingredients = recipe.ingredients
        coreDataStack.saveContext()
    }
    
    func removeRecipe(named name: String) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        guard let recipes = try? managedObjectContext.fetch(request) else { return }
        if recipes.isEmpty { return }
        managedObjectContext.delete(recipes[0])
        coreDataStack.saveContext()
    }
    
    func isRegistered(named name: String) -> Bool {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        guard let recipes = try? managedObjectContext.fetch(request) else { return false }
        if recipes.isEmpty { return false }
        return true
    }
}
