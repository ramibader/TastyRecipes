//
//  SearchVC.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class SearchVC: UIViewController {
	
	let searchTextField = TRTextField()
	let actionButton = TRActionButton(backgroundColor: .systemPurple, title: "Get Recipes")
	let logoImageView = UIImageView(image: Images.logoImage)
	
	var isTermEntered: Bool { return !searchTextField.text!.isEmpty }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViewController()
		setupUILayout()
		createDismissKeyboardTapGesture()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	func setupViewController() {
		title = "Search"
		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
		searchTextField.delegate = self
	}
	
	func setupUILayout() {
		
		view.addSubview(searchTextField)
		view.addSubview(actionButton)
		view.addSubview(logoImageView)
		
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		
		actionButton.addTarget(self, action: #selector(pushRecipesListVC), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			
			logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
			logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
			logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
			logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
			
			searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
			searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
			searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
			searchTextField.heightAnchor.constraint(equalToConstant: 48),
			
			actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
			actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
			actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
			actionButton.heightAnchor.constraint(equalToConstant: 48)
		])
		
	}
	
	func createDismissKeyboardTapGesture() {
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tap)
	}
	
	@objc func pushRecipesListVC() {
		guard isTermEntered else {
			TRAlert.presentAlert(on: self, title: "Enter a search term", message: "Enter a search term into the search field. We need to know what to look for.")
			return
		}
		
		searchTextField.resignFirstResponder()
		
		let recipesListVC = RecipesListVC(term: searchTextField.text!)
		navigationController?.pushViewController(recipesListVC, animated: true)
	}

}

extension SearchVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		print("Tapped return")
		pushRecipesListVC()
		return true
	}
}
