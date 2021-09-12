//
//  PersistenceManager.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import Foundation

enum PersistenceActionType {
	case add, remove
}


enum PersitenceManager {
	
	static private let defaults = UserDefaults.standard
	
	enum Keys {
		static let recipes = "recipes"
	}
	
	static func updateWith(recipe: RecipeDetail, actionType: PersistenceActionType, completed: @escaping (TRError?) -> Void) {
		retrieveFavorites { result in
			switch result {
			case .success(let recipes):
				var retrievedRecipes = recipes
				
				switch actionType {
				case .add:
					guard !retrievedRecipes.contains(recipe) else {
						completed(.alreadyInFavorites)
						return
					}
					
					retrievedRecipes.insert(recipe, at: 0)
					
				case .remove:
					retrievedRecipes.removeAll { $0.id == recipe.id }
				}
				
				completed(save(recipes: retrievedRecipes))
				
			case .failure(let error):
				completed(error)
			}
		}
	}
	
	
	static func retrieveFavorites(completed: @escaping (Result<[RecipeDetail], TRError>) -> Void) {
		guard let favoritesData = defaults.object(forKey: Keys.recipes) as? Data else {
			completed(.success([]))
			return
		}
		
		do {
			let decoder = JSONDecoder()
			let recipes = try decoder.decode([RecipeDetail].self, from: favoritesData)
			completed(.success(recipes))
		} catch {
			completed(.failure(.unableToFavorite))
		}
	}
	
	
	static func save(recipes: [RecipeDetail]) -> TRError? {
		do {
			let encoder = JSONEncoder()
			let encodedRecipes = try encoder.encode(recipes)
			defaults.set(encodedRecipes, forKey: Keys.recipes)
			return nil
		} catch {
			return .unableToFavorite
		}
	}
}
