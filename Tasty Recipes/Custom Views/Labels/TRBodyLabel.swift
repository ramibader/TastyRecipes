//
//  TRBodyLabel.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class TRBodyLabel: UILabel {

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
		minimumScaleFactor = 0.85
		font = UIFont.preferredFont(forTextStyle: .body)
		textColor = .secondaryLabel
	}

}
