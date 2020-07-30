//
//  SearchController.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import UIKit

final class SearchController: UIViewController {

    // MARK: - Properties
    
    private var searchService: SearchRecipe = SearchRecipe()
    private var requestService: EdamamService = EdamamService()
    private var ingredients: [Ingredient]!
    private var recipes = [Recipe]()
    typealias completion = () -> ()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet private weak var waitingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var buttonStackView: UIStackView!
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        initBackgroundLogic()
    }
    
    // MARK: - User actions
    
    @IBAction private func tapSearchButton() {
        hideWaitingActivityIndicator(true)
        prepareAPICall(with: searchService.ingredients) {
            requestService.getRecipes { [unowned self] result in
                switch result {
                case .success(let recipes):
                    DispatchQueue.main.async {
                        self.createRecipes(with: recipes)
                        self.performSegue(withIdentifier: "tapSearchButton", sender: nil)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.sendAlert(.network)
                    }
                }
            }
        }
        hideWaitingActivityIndicator(false)
    }
    
    @IBAction private func tapResetButton() {
        searchService.reset()
        for ingredient in ingredients {
            ingredient.choosed = false
        }
        ingredientsCollectionView.reloadData()
    }
    
    // MARK: - Private method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tapSearchButton" {
            if let destination = segue.destination as? SearchResultController {
                destination.recipes = [Recipe]()
            }
        }
    }
    
    private func hideWaitingActivityIndicator(_ bool: Bool) {
        buttonStackView.isHidden = !bool
        waitingActivityIndicator.isHidden = bool
    }
    
    private func createRecipes(with recipes: [RecipeFromAPI]) {
        for recipe in recipes {
            self.recipes.append(Recipe(withAPICall: recipe))
        }
    }
    
    private func prepareAPICall(with ingredients: [Ingredient], completion: completion) {
        for ingredient in ingredients {
            requestService.updateBody(with: ingredient.name)
        }
        completion()
    }
    
    private func initUI() {
        searchButton.layer.cornerRadius = 15
        resetButton.layer.cornerRadius = 15
        resetButton.layer.borderWidth = 3
        resetButton.layer.borderColor = UIColor(red: 225/255, green: 127/255, blue: 133/255, alpha: 1).cgColor
        waitingActivityIndicator.isHidden = true
    }
    
    private func initBackgroundLogic() {
        ingredients = Ingredient.list
        let nib: UINib = UINib(nibName: "IngredientCollectionViewCell", bundle: nil)
        ingredientsCollectionView.register(nib, forCellWithReuseIdentifier: "IngredientCell")
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.delegate = self
    }
}

// MARK: - Extension for CollectionView

// Data source : init number and customization of cells
extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCell", for: indexPath) as? IngredientCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: ingredients[indexPath.item])
        return cell
    }
}

// Delegate : react to user action
extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch ingredients[indexPath.item].choosed {
        case true:
            searchService.remove(ingredient: ingredients[indexPath.item])
        case false:
            searchService.add(ingredient: Ingredient(name: ingredients[indexPath.item].name))
        }
        ingredients[indexPath.item].choosed = !ingredients[indexPath.item].choosed
        ingredientsCollectionView.reloadData()
    }
}
