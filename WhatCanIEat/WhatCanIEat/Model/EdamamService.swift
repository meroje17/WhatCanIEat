//
//  EdamamService.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import Foundation

// Struct to decode JSON ID
struct EdamamID: Decodable {
    let ID: [String: String]
}

// All struct to decode API Result
struct EdamamResult: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: RecipeFromAPI
}

struct RecipeFromAPI: Decodable {
    var label: String
    var image: String
    var url: String
    var ingredientLines: [String]
}

// All errors enum
enum EdamamError: Error {
    case noData
    case noResponse
    case URLNotFounded
    case undecodable
}

final class EdamamService {
    
    // MARK: - Properties
    
    private var session: URLSession
    private var task: URLSessionTask?
    private var body = [String: String]()
    
    // MARK: - Initializer
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        self.body = loadJSON()
    }
    
    // MARK: - Public methods
    
    func getRecipes(callback: @escaping (Result<[RecipeFromAPI], EdamamError>) -> Void) {
        guard let baseUrl = URL(string: "https://api.edamam.com/search?") else {
            callback(.failure(.URLNotFounded))
            return
        }
        let url = createURL(baseUrl, body)
        task = session.dataTask(with: url) { [unowned self] (data, response, error) in
            let decoder = JSONDecoder()
            guard let data = data, error != nil else {
                callback(.failure(.noData))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(.failure(.noResponse))
                return
            }
            guard let result = try? decoder.decode(EdamamResult.self, from: data) else {
                callback(.failure(.undecodable))
                return
            }
            let recipes = self.returningAllRecipes(result)
            callback(.success(recipes))
        }
    }
    
    func resetBody() {
        body = loadJSON()
    }
    
    func updateBody(with value: String) {
        if body["q"] != nil {
            guard let currentValue = body["q"] else { return }
            let updatedValue = currentValue + "+" + value
            body.updateValue(updatedValue, forKey: "q")
        } else {
            body.updateValue(value, forKey: "q")
        }
    }
    
    // MARK: - Private methods
    
    private func loadJSON() -> [String: String] {
        let decoder = JSONDecoder()
        guard let url = Bundle.main.url(forResource: "EdamamID", withExtension: "json") else { return [String: String]() }
        guard let data = try? Data(contentsOf: url) else { return [String: String]() }
        guard let result = try? decoder.decode(EdamamID.self, from: data) else { return [String: String]() }
        return result.ID
    }
    
    private func createURL(_ baseUrl: URL, _ parameters: [String: String]) -> URL {
        guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false), !parameters.isEmpty else {
            return baseUrl
        }
        urlComponents.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: value)
            urlComponents.queryItems?.append(queryItem)
        }
        guard let urlParameted = urlComponents.url else { return baseUrl }
        return urlParameted
    }
    
    private func returningAllRecipes(_ edamam: EdamamResult) -> [RecipeFromAPI] {
        var result = [RecipeFromAPI]()
        for recipe in edamam.hits {
            result.append(recipe.recipe)
        }
        return result
    }
}
