//
//  Constructor.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

struct Constructor {
	static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
		let width = view.bounds.width
		let padding: CGFloat = 12
		let minimumItemSpacing: CGFloat = 10
		let availableWidth = width - (padding *  2) - (minimumItemSpacing * 2)
		let itemWidth = availableWidth / 2
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 60)
		
		return flowLayout
	}
}
