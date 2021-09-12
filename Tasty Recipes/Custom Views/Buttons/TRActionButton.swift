//
//  TRActionButton.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class TRActionButton: UIButton {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	convenience init(backgroundColor: UIColor, title: String) {
		self.init(frame: .zero)
		set(backgroundColor: backgroundColor, title: title)
	}
	
	
	private func configure() {
		layer.cornerRadius = 10
		setTitleColor(.white, for: .normal)
		titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		setTitleColor(.white.withAlphaComponent(0.8), for: .highlighted)
		setTitleColor(.systemGray, for: .disabled)
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	
	func set(backgroundColor: UIColor, title: String) {
		self.backgroundColor = backgroundColor
		setTitle(title, for: .normal)
	}
}
