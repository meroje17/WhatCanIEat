//
//  SearchService.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import Foundation

final class SearchRecipe {
    
    // MARK: - Properties
    
    var ingredients = [Ingredient]()
    
    // MARK: - Methods
    
    func add(ingredient: Ingredient) {
        ingredients.append(ingredient)
    }
    
    func remove(ingredient: Ingredient) {
        ingredients.removeAll(where: { $0.name == ingredient.name })
    }
    
    func reset() {
        ingredients = [Ingredient]()
    }
}
