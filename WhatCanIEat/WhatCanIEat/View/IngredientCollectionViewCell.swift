//
//  IngredientCollectionViewCell.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import UIKit

final class IngredientCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var viewToRounded: UIView!
    @IBOutlet private weak var ingredientName: UILabel!
    @IBOutlet private weak var ingredientImage: UIImageView!
    @IBOutlet private weak var choosedImage: UIImageView!
    
    // MARK: - Initializer
    
    fileprivate func initUI() {
        viewToRounded.layer.cornerRadius = 20
        viewToRounded.layer.borderWidth = 2
        viewToRounded.layer.borderColor = UIColor.white.cgColor
        viewToRounded.layer.shadowColor = UIColor.black.cgColor
        viewToRounded.layer.shadowOpacity = 0.2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initUI()
    }
    
    // MARK: - Method to init UI with Ingredient object
    
    func configure(with ingredient: Ingredient) {
        ingredientName.text = ingredient.name
        ingredientImage.image = UIImage(named: ingredient.name)
        switch ingredient.choosed {
        case true:
            choosedImage.image = UIImage(systemName: "circle.fill")
        case false:
            choosedImage.image = UIImage(systemName: "circle")
        }
    }
}
