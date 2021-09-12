//
//  Wrapper.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import Foundation

class Wrapper<S>: NSObject {

	let value: S

	init(_ _struct: S) {
		self.value = _struct
	}
}
