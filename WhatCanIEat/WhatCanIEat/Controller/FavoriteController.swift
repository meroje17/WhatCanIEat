//
//  FavoriteController.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import UIKit

final class FavoriteController: UIViewController {

    // MARK: - Properties
    
    private var recipeToSend: Recipe!
    private var recipes: [Recipe] = [Recipe]()
    private var coreDataService = CoreDataManager(coreDataStack: CoreDataStack(named: "WhatCanIEat"))
    
    // MARK: - Outlet
    
    @IBOutlet private weak var favoriteRecipeTableView: UITableView!
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBackgroundLogic()
        for recipe in coreDataService.recipes {
            recipes.append(Recipe(withCoreData: recipe))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recipes = [Recipe]()
        for recipe in coreDataService.recipes {
            recipes.append(Recipe(withCoreData: recipe))
        }
        favoriteRecipeTableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func initBackgroundLogic() {
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        favoriteRecipeTableView.register(nib, forCellReuseIdentifier: "RecipeCell")
        favoriteRecipeTableView.delegate = self
        favoriteRecipeTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteRecipeChoosing" {
            if let destination = segue.destination as? DetailController {
                guard let recipe = recipeToSend else { return }
                destination.recipe = recipe
            }
        }
    }
}

// MARK: - Extension for Table View

// Data source : init number and customization of cell
extension FavoriteController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        cell.configure(with: recipes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Add some recipes in the list"
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if recipes.isEmpty {
            return 200
        } else {
            return 0
        }
    }
}

// Delegate : react to user action
extension FavoriteController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeToSend = recipes[indexPath.row]
        performSegue(withIdentifier: "favoriteRecipeChoosing", sender: nil)
    }
}
