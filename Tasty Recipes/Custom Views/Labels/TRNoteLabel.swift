//
//  TRNoteLabel.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class TRNoteLabel: UILabel {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		font = UIFont.preferredFont(forTextStyle: .footnote)
		textColor = .secondaryLabel
		numberOfLines = 0
	}

}
