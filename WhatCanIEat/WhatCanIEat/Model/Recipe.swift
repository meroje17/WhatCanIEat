//
//  Recipe.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import Foundation

final class Recipe {
    
    // MARK: - Properties
    
    static var list = [Recipe]()
    
    var name: String
    var image: String
    var url: String
    var ingredients: [String]
    
    // MARK: - Initializer
    
    init(withCoreData recipe: RecipeEntity) {
        self.name = recipe.name ?? String()
        self.image = recipe.image ?? String()
        self.url = recipe.url ?? String()
        self.ingredients = recipe.ingredients ?? [String]()
    }
    
    init(withAPICall recipe: RecipeFromAPI) {
        self.name = recipe.label
        self.image = recipe.image
        self.url = recipe.url
        self.ingredients = recipe.ingredientLines
    }
}
