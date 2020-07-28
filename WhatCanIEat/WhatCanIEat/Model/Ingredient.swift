//
//  Ingredient.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import Foundation

// Struct to decode the "Ingredients.json"

struct IngredientFileToDecode: Decodable {
    let list: [String]
}

final class Ingredient {
    
    // MARK: - Properties
    
    static var list: [Ingredient] {
        let names = loadJSON()
        let list = createIngredientArray(with: names)
        return list
    }
    
    var name: String
    var choosed = false
    
    // MARK: - Initializer
    
    init(name: String) {
        self.name = name
    }
    
    // MARK: - Ingredients load methods
    
    // Load JSON strings
    static private func loadJSON() -> [String] {
        let decoder = JSONDecoder()
        guard let url = Bundle.main.url(forResource: "Ingredients", withExtension: "json") else { return [String]() }
        guard let data = try? Data(contentsOf: url) else { return [String]() }
        guard let result = try? decoder.decode(IngredientFileToDecode.self, from: data) else { return [String]() }
        return result.list
    }
    
    // Uppercased name
    static private func uppercase(_ name: String) -> String {
        let uppercasedName = name.prefix(1).uppercased() + name.dropFirst()
        return uppercasedName
    }
    
    // Create ingredients array with all theirs names
    static private func createIngredientArray(with names: [String]) -> [Ingredient] {
        var ingredients = [Ingredient]()
        for name in names {
            let uppercasedName = uppercase(name)
            ingredients.append(Ingredient(name: uppercasedName))
        }
        return ingredients
    }
}
