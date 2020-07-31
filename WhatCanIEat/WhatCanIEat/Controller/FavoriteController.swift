//
//  FavoriteController.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import UIKit

final class FavoriteController: UIViewController {

    // MARK: - Property
    
    var recipe: Recipe!
    
    // MARK: - Outlet
    
    @IBOutlet private weak var favoriteRecipeTableView: UITableView!
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
