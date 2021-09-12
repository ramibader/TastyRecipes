//
//  Wrapper.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

///This is a NSObject to Struct wrapper. It encapsulates custom structs to NSObject, which is needed to save to NSCache, which does not support Swift structs. Wrapper takes a parameter and saves it into a value, making the stored struct available via Wrapper.value
///
///*NSCacheInstance*.setObject(Wrapper(*value*), forKey: *cacheKey*)

import Foundation

class Wrapper<S>: NSObject {

	let value: S

	init(_ value: S) {
		self.value = value
	}
}
