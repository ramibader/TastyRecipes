//
//  RecipeCell.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class RecipeCell: UICollectionViewCell {
	static let reuseID = Identifiers.RecipeCell
	
	let nameLabel = TRSmallTitleLabel(frame: .zero)
	let foodImage = TRImageView(frame: .zero)
	
	func set(recipe: Recipe) {
		nameLabel.text = recipe.name
		NetworkManager.shared.downloadImage(from: recipe.thumbnailUrl) { [weak self] image in
			guard let self = self else { return }
			if image != nil {
				DispatchQueue.main.async { self.foodImage.image = image }
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		addSubview(nameLabel)
		addSubview(foodImage)
		
		let padding: CGFloat = 8
		
		NSLayoutConstraint.activate([
			foodImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
			foodImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
			foodImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
			foodImage.heightAnchor.constraint(equalTo: foodImage.widthAnchor),
			
			nameLabel.topAnchor.constraint(equalTo: foodImage.bottomAnchor, constant: 12),
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
			nameLabel.heightAnchor.constraint(equalToConstant: 44)
		])
	}
}

