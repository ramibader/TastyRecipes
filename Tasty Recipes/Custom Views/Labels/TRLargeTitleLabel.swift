//
//  TRLargeTitleLabel.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class TRLargeTitleLabel: UILabel {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		numberOfLines = 0
		sizeToFit()
		adjustsFontSizeToFitWidth = true
		minimumScaleFactor = 0.75
		textColor = .white
		textAlignment = .natural
		
		font = UIFont.systemFont(ofSize: 36, weight: .black)
		
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowRadius = 3
		layer.shadowOpacity = 0.9
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.masksToBounds = false
	}
	
}
