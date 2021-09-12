//
//  RecipesListVC.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class RecipesListVC: UIViewController {
	
	enum Section { case main }
	
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, Recipe>!
	
	var term: String!
	
	var page = 1
	
	init(term: String) {
		super.init(nibName: nil, bundle: nil)
		self.term = term
		self.title = term + " " + "recipes"
	}
	
	var recipes: [Recipe] = []
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		configureCollectionView()
		configureDataSource()
		downloadRecipes(page: page)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	func downloadRecipes(page: Int) {
		showLoadingView()
		NetworkManager.shared.getRecipesList(for: term, page: page) { [weak self] result in
			guard let self = self else { return }
			self.dismissLoadingView()
			switch result {
			case .success(let result):
				dump(result, name: "Result")
				self.recipes.append(contentsOf: result.results)
				self.updateData(on: self.recipes)
			case .failure(let error):
				dump(error, name: "Error")
				TRAlert.presentErrorAlert(on: self, error: error)
			}
		}
	}
	
	
	//MARK: Collection view configuration
	func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Constructor.createTwoColumnFlowLayout(in: view))
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.backgroundColor = .systemBackground
		collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseID)
	}
	
	func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, Recipe>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, recipe) -> UICollectionViewCell? in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseID, for: indexPath) as! RecipeCell
			cell.set(recipe: recipe)
			return cell
		})
	}
	
	
	func updateData(on recipes: [Recipe]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>()
		snapshot.appendSections([.main])
		snapshot.appendItems(recipes)
		DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
	}

}

extension RecipesListVC: UICollectionViewDelegate {
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY         = scrollView.contentOffset.y
		let contentHeight   = scrollView.contentSize.height
		let height          = scrollView.frame.size.height

		if offsetY > contentHeight - height {
			page += 1
			downloadRecipes(page: page)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let recipe = recipes[indexPath.item]

		dump(recipe, name: "Selected recipe at \(indexPath.item)")
		
		let detailVC = RecipeDetailVC(recipe: recipe)
		
		present(detailVC, animated: true)
	}
}
