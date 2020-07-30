//
//  RecipeTableViewCell.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import UIKit

final class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var recipeName: UILabel!
    
    // MARK: - Method to init UI with Recipe object
    
    // Init UI
    func configure(with recipe: Recipe) {
        guard let url = URL(string: recipe.url) else { return }
        recipeName.text = recipe.name
        load(url)
    }
    
    // Load an image for recipeImage with recipe url
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
