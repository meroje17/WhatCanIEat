//
//  SearchResultController.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 28/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import UIKit

final class SearchResultController: UIViewController {

    // MARK: - Properties
    
    var recipes: [Recipe] = [Recipe]()
    private var recipeToSend: Recipe?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var recipeTableView: UITableView!
    @IBOutlet private weak var returnButton: UIButton!
    
    // MARK: - User action
    
    @IBAction private func tapReturnButton() {
        recipes = [Recipe]()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBackgroundLogic()
        initUI()
    }
    
    // MARK: - Private methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeChoosing" {
            if let destination = segue.destination as? DetailController {
                guard let recipe = recipeToSend else { return }
                destination.recipe = recipe
            }
        }
    }
    
    private func initUI() {
        returnButton.layer.cornerRadius = 30
    }
    
    private func initBackgroundLogic() {
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        recipeTableView.register(nib, forCellReuseIdentifier: "RecipeCell")
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
    }
}

// MARK: - Extension for TableView

// Data source : init number and customization of cell
extension SearchResultController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        cell.configure(with: recipes[indexPath.row])
        return cell
    }
}

// Delegate : react to user action
extension SearchResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeToSend = recipes[indexPath.row]
        performSegue(withIdentifier: "recipeChoosing", sender: nil)
    }
}
