//
//  FavoriteCell.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class FavoriteCell: UITableViewCell {
	
	static let reuseID = Identifiers.FavoriteCell
	
	let thumbnailImageView: UIImageView = {
		let thumbnailImageView = TRThumbnailImageView(frame: .zero)
		thumbnailImageView.clipsToBounds = true
		thumbnailImageView.layer.cornerRadius = 8
		thumbnailImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
		thumbnailImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
		return thumbnailImageView
	}()
	
	let nameLabel: UILabel = {
		let nameLabel = TRTitleLabel(frame: .zero)
		nameLabel.numberOfLines = 3
		nameLabel.textAlignment = .natural
		return nameLabel
	}()
	
	let descriptionLabel: UILabel = {
		let descriptionLabel = TRBodyLabel(frame: .zero)
		descriptionLabel.numberOfLines = 4
		return descriptionLabel
	}()
	
	func set(recipe: RecipeDetail) {
		nameLabel.text = recipe.name
		descriptionLabel.text = recipe.description
		downloadImage(from: recipe.thumbnailUrl)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		
		let padding: CGFloat = 12
		
		let horizontalStack: UIStackView = {
			let HStack = UIStackView()
			HStack.axis = .horizontal
			HStack.spacing = padding
			HStack.distribution = .fill
			HStack.alignment = .top
			HStack.translatesAutoresizingMaskIntoConstraints = false
			HStack.addArrangedSubview(thumbnailImageView)
			HStack.addArrangedSubview(nameLabel)
			return HStack
		}()
		
		let stack: UIStackView = {
			let stack = UIStackView()
			stack.axis = .vertical
			stack.spacing = padding/2
			stack.distribution = .equalSpacing
			stack.translatesAutoresizingMaskIntoConstraints = false
			stack.addArrangedSubview(horizontalStack)
			stack.addArrangedSubview(descriptionLabel)
			return stack
		}()
		
		addSubview(stack)
		
		accessoryType = .disclosureIndicator
		
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: topAnchor, constant: padding),
			stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
		])
	}
	
	private func downloadImage(from url: String) {
		NetworkManager.shared.downloadImage(from: url) { [weak self] image in
			guard let self = self else { return }
			if image != nil {
				DispatchQueue.main.async { self.thumbnailImageView.image = image }
			}
		}
	}
	
}
