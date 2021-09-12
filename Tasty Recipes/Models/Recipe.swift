//
//  Recipe.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import Foundation

struct Recipes: Codable {
	let results: [Recipe]
}

struct Recipe: Codable, Hashable {
	let name: String
	let id: Int
	let thumbnailUrl: String
}

struct RecipeDetail: Codable, Identifiable, Equatable {
	
	static func == (lhs: RecipeDetail, rhs: RecipeDetail) -> Bool {
		return lhs.id == rhs.id
	}
	
	let id: Int
	
	let name: String
	let thumbnailUrl: String
	let description: String
	let instructions: [Instruction]
	let sections: [Section]
}

struct Instruction: Codable {
	let displayText: String
	let position: Int
}

struct Section: Codable {
	let components: [Component]
	let position: Int
}

struct Component: Codable {
	let id: Int
	let rawText, extraComment: String
	let position: Int
	let measurements: [Measurement]
	let ingredient: Ingredient

	enum CodingKeys: String, CodingKey {
		case id
		case rawText
		case extraComment
		case position, measurements, ingredient
	}
}

struct Ingredient: Codable {
	let updatedAt, id: Int
	let name, displaySingular, displayPlural: String
	let createdAt: Int

	enum CodingKeys: String, CodingKey {
		case updatedAt
		case id, name
		case displaySingular
		case displayPlural
		case createdAt
	}
}

struct Measurement: Codable {
	let id: Int
	let quantity: String
	let unit: Unit
}

struct Unit: Codable {
	let name, abbreviation, displaySingular, displayPlural: String

	enum CodingKeys: String, CodingKey {
		case name, abbreviation
		case displaySingular
		case displayPlural
	}
}
