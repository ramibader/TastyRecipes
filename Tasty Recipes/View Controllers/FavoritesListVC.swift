//
//  FavoritesListVC.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class FavoritesListVC: UIViewController {

	let tableView = UITableView()
	
	var favorites = [RecipeDetail]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViewController()
		setupTableView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: true)
		getFavorites()
	}
	
	private func setupViewController() {
		title = "Favorites"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func setupTableView() {
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func getFavorites() {
		PersitenceManager.retrieveFavorites { [weak self] result in
			
			guard let self = self else { return }
			
			switch result {
				case .success(let favorites):
					self.favorites = favorites
					self.tableView.reloadData()
				case .failure(let error):
					TRAlert.presentErrorAlert(on: self, error: error)
			}
		}
	}

}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return favorites.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
		let favorite = favorites[indexPath.row]
		cell.set(recipe: favorite)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let recipe = favorites[indexPath.row]
		let detailVC = RecipeDetailVC(recipeID: recipe.id)

		present(detailVC, animated: true)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		
		let favorite = favorites[indexPath.row]
		
		PersitenceManager.updateWith(recipe: favorite, actionType: .remove) { [weak self] error in
			guard let self = self else { return }
			guard let error = error else {
				self.favorites.remove(at: indexPath.row)
				self.tableView.deleteRows(at: [indexPath], with: .left)
				return
			}
			TRAlert.presentErrorAlert(on: self, error: error)
		}
	}
	
}
