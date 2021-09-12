//
//  TRSmallTitleLabel.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class TRSmallTitleLabel: UILabel {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure(alignment: .center)
	}
	
	init(alignment: NSTextAlignment) {
		super.init(frame: .zero)
		configure(alignment: alignment)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure(alignment: NSTextAlignment) {
		font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		textColor = .label
		numberOfLines = 2
		adjustsFontSizeToFitWidth = true
		minimumScaleFactor = 0.9
		lineBreakMode = .byTruncatingTail
		translatesAutoresizingMaskIntoConstraints = false
		textAlignment = alignment
	}

}
