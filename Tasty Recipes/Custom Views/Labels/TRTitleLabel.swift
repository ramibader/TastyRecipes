//
//  TRTitleLabel.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class TRTitleLabel: UILabel {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		
		numberOfLines = 2
		sizeToFit()
		adjustsFontSizeToFitWidth = true
		minimumScaleFactor = 0.9
		font = UIFont.systemFont(ofSize: 22, weight: .semibold)
		textColor = .label
		textAlignment = .center
	}

}
