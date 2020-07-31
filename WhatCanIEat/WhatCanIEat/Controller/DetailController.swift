//
//  DetailController.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import UIKit

final class DetailController: UIViewController {

    // MARK: - Properties
    
    var recipe: Recipe!
    private var coreDataService = CoreDataManager(coreDataStack: CoreDataStack(named: "WhatCanIEat"))
    
    // MARK: - Outlets
    
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var goToWebsiteButton: UIButton!
    @IBOutlet private weak var recipeName: UILabel!
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    // MARK: - Actions
    
    @IBAction private func tapReturnButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func tapFavoriteButton() {
        if coreDataService.isRegistered(named: recipe.name) {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            coreDataService.removeRecipe(named: recipe.name)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            coreDataService.createFavoriteRecipe(with: recipe)
        }
    }
    
    @IBAction private func tapGoToWebsiteButton() {
        guard let url = URL(string: recipe.url) else {
            sendAlert(.urlNotFounded)
            return
        }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Private methods
    
    private func initUI() {
        guard let url = URL(string: recipe.image) else { return }
        if coreDataService.isRegistered(named: recipe.name) {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        load(url)
        recipeName.text = recipe.name
        ingredientsLabel.text = String()
        for ingredient in recipe.ingredients {
            ingredientsLabel.text! += ingredient + "\n"
        }
        goToWebsiteButton.layer.cornerRadius = 10
    }
    
    private func load(_ url: URL) {
        DispatchQueue.global().async { [unowned self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.recipeImage.image = image
                    }
                }
            }
        }
    }
}
