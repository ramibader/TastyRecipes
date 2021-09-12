//
//  RecipesDetailVC.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class RecipeDetailVC: UIViewController {
	
	let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()
	
	let containerView: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		return containerView
	}()
	
	
	let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 24
		stackView.distribution = .equalSpacing
		return stackView
	}()
	
	let ingredientsStackView: UIStackView = {
		let ingredientsStackView = UIStackView()
		ingredientsStackView.axis = .vertical
		ingredientsStackView.spacing = 12
		ingredientsStackView.distribution = .equalSpacing
		return ingredientsStackView
	}()
	
	let instructionsStackView: UIStackView = {
		let instructionsStackView = UIStackView()
		instructionsStackView.axis = .vertical
		instructionsStackView.spacing = 12
		instructionsStackView.distribution = .equalSpacing
		return instructionsStackView
	}()
	
	let thumbnailImageView = TRThumbnailImageView(frame: .zero)
	let backgroundImageView = TRThumbnailImageView(frame: .zero)
	let recipeTitleLabel = TRLargeTitleLabel()
	let descriptionLabel = TRBodyLabel(frame: .zero)
	
	let actionButton: UIButton = {
		let actionButton = TRActionButton(backgroundColor: .systemPurple, title: "Save to Favorites")
		actionButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		//actionButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
		return actionButton
	}()
	
	var recipeID: Int!
	var recipe: RecipeDetail!
	
	init(recipe: Recipe) {
		super.init(nibName: nil, bundle: nil)
		self.recipeID = recipe.id
	}
	
	init(recipeID: Int) {
		super.init(nibName: nil, bundle: nil)
		self.recipeID = recipeID
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViewController()
		downloadRecipeInfo()
	}
	
	private func downloadRecipeInfo() {
		showLoadingView()
		NetworkManager.shared.getRecipe(for: recipeID) { [weak self] result in
			guard let self = self else { return }
			self.dismissLoadingView()
			switch result {
				case .success(let recipe):
					dump(recipe, name: "Recipe result")
					self.recipe = recipe
					DispatchQueue.main.async {
						self.setupScrollView()
						self.layoutUI()
						self.populateUI()
					}
				case .failure(_):
					DispatchQueue.main.async {
						self.setupFailureMessage()
					}
			}
		}
	}
	
	private func setupFailureMessage() {
		
		let failureLabel: TRTitleLabel = {
			let failureLabel = TRTitleLabel(frame: .zero)
			failureLabel.text = "This app is not yet ready to display every recipe available 😞. We are sorry for this inconvenience."
			failureLabel.textColor = .secondaryLabel
			failureLabel.numberOfLines = 0
			return failureLabel
		}()
		
		actionButton.setTitle("Go back", for: .normal)
		actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		
		let stack: UIStackView = {
			let stack = UIStackView()
			stack.axis = .vertical
			stack.spacing = 22
			stack.distribution = .fill
			stack.alignment = .center
			stack.translatesAutoresizingMaskIntoConstraints = false
			stack.addArrangedSubview(failureLabel)
			stack.addArrangedSubview(actionButton)
			return stack
		}()
		
		view.addSubview(stack)
		
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
			stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
			stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
			stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
		])
		
		actionButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
		
	}
	
	private func setupViewController() {
		view.backgroundColor = .secondarySystemBackground
	}
	
	@objc private func dismissVC() {
		dismiss(animated: true)
	}
	
	private func setupScrollView() {
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		
		NSLayoutConstraint.activate([
			containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
		])
		
	}
	
	private func setupTitleLabel() {
		
		containerView.addSubview(recipeTitleLabel)
		
		NSLayoutConstraint.activate([
			recipeTitleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: 22),
			recipeTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 22),
			recipeTitleLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -22),
			recipeTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5)
		])
		
	}
	
	private func layoutUI() {
		setupBackgroundImageView()
		setupThumbnailImageView()
		setupTitleLabel()
		setupStackView()
	}
	
	private func populateUI() {
		downloadImage()
		recipeTitleLabel.text = recipe.name
		descriptionLabel.text = recipe.description
	}
	
	func setupStackView() {
		
		containerView.addSubview(stackView)
		
		if !recipe.description.isEmpty {
			stackView.addArrangedSubview(descriptionLabel)
		}
		
		setupIngredientsStack()
		setupInstructionsStack()
		setupSaveButton()
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 26),
			stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
			stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),
			stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18)
		])
		
	}
	
	func setupBackgroundImageView() {
		
		containerView.addSubview(backgroundImageView)
		
		backgroundImageView.layer.shadowColor = UIColor.black.cgColor
		backgroundImageView.layer.shadowRadius = 10
		backgroundImageView.layer.shadowOpacity = 0.6
		backgroundImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
		
		NSLayoutConstraint.activate([
			backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
			backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			backgroundImageView.widthAnchor.constraint(equalTo: backgroundImageView.heightAnchor)
		])
		
		let blur = UIBlurEffect(style: .regular)
		let blurView = UIVisualEffectView(effect: blur)
		blurView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(blurView)
		
		NSLayoutConstraint.activate([
			blurView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
			blurView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
			blurView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
			blurView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
		])
	}
	
	private func setupThumbnailImageView() {
		
		//containerView.addSubview(thumbnailImageView)
		
		let shadowView = UIView()
		shadowView.translatesAutoresizingMaskIntoConstraints = false
		shadowView.layer.cornerRadius = 12
		shadowView.layer.shadowColor = UIColor.black.cgColor
		shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
		shadowView.layer.shadowRadius = 20
		shadowView.layer.shadowOpacity = 1
		
		containerView.addSubview(shadowView)
		
		NSLayoutConstraint.activate([
			shadowView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 34),
			shadowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 34),
			shadowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -34),
			shadowView.heightAnchor.constraint(equalTo: shadowView.widthAnchor)
		])
		
		shadowView.addSubview(thumbnailImageView)
		
		thumbnailImageView.clipsToBounds = true
		thumbnailImageView.layer.cornerRadius = 12
		
		NSLayoutConstraint.activate([
			thumbnailImageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
			thumbnailImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
			thumbnailImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
			thumbnailImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
		])
	}
	
	private func setupIngredientsStack() {
		
		let ingredientsLabel: TRSmallTitleLabel = {
			let label = TRSmallTitleLabel(alignment: .natural)
			label.text = "Ingredients"
			return label
		}()
		
		ingredientsStackView.addArrangedSubview(ingredientsLabel)
		
		for i in recipe.sections {
			
			for n in i.components {
				
				let dot: UIImageView = {
					let dot = UIImageView(image: UIImage(systemName: "circle.fill"))
					dot.tintColor = .systemPurple
					dot.heightAnchor.constraint(equalToConstant: 10).isActive = true
					dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
					return dot
				}()
				
				let label: TRNoteLabel = {
					let label = TRNoteLabel()
					label.numberOfLines = 0
					label.text = n.rawText
					return label
				}()
				
				let stack: UIStackView = {
					let stack = UIStackView()
					stack.axis = .horizontal
					stack.spacing = 6
					stack.distribution = .fill
					stack.alignment = .top
					stack.addArrangedSubview(dot)
					stack.addArrangedSubview(label)
					return stack
				}()
				
				ingredientsStackView.addArrangedSubview(stack)
			}
		}
		
		stackView.addArrangedSubview(ingredientsStackView)
		
	}
	
	private func setupInstructionsStack() {
		
		let instructionsLabel: TRSmallTitleLabel = {
			let label = TRSmallTitleLabel(alignment: .natural)
			label.text = "Instructions"
			return label
		}()
		
		instructionsStackView.addArrangedSubview(instructionsLabel)
		
		for i in recipe.instructions {
			
			let dot: UIImageView = {
				let dot = UIImageView(image: UIImage(systemName: "circle.fill"))
				dot.tintColor = .systemPurple
				dot.heightAnchor.constraint(equalToConstant: 10).isActive = true
				dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
				return dot
			}()
			
			let label: TRNoteLabel = {
				let label = TRNoteLabel()
				label.numberOfLines = 0
				label.text = i.displayText
				return label
			}()
			
			let stack: UIStackView = {
				let stack = UIStackView()
				stack.axis = .horizontal
				stack.spacing = 6
				stack.distribution = .fill
				stack.alignment = .top
				stack.addArrangedSubview(dot)
				stack.addArrangedSubview(label)
				return stack
			}()
			
			instructionsStackView.addArrangedSubview(stack)
		}
		
		stackView.addArrangedSubview(instructionsStackView)
		
	}
	
	private func setupSaveButton() {
		actionButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
		stackView.addArrangedSubview(actionButton)
	}
	
	@objc func addToFavorites() {
		PersitenceManager.updateWith(recipe: recipe, actionType: .add) { [weak self] error in
			guard let self = self else { return }
			guard let error = error  else {
				TRAlert.presentAlert(on: self, title: "Success", message: "You have succesfully favorited this recipe!")
				return
			}
			TRAlert.presentErrorAlert(on: self, error: error)
		}
	}
	
	private func downloadImage() {
		NetworkManager.shared.downloadImage(from: recipe.thumbnailUrl) { [weak self] image in
			guard let self = self else { return }
			if image != nil {
				DispatchQueue.main.async {
					self.thumbnailImageView.image = image
					self.backgroundImageView.image = image
				}
			}
		}
	}
	
}
