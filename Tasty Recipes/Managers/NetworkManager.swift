//
//  NetworkManager.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

/// Network manager is implemented as a singleton and accessed via its shared property.
/// There are three separate caches implemented for images, recipe lists and recipe details. Content of these
/// rarely changes (some of them nearly never) so it is fine to cache them to decrease the number
/// API calls and network bandwith as the user will probably display these no more then once in a single app session.

import UIKit

class NetworkManager {
	
	static let shared = NetworkManager()
	let imagesCache = NSCache<NSString, UIImage>()
	let recipesCache = NSCache<NSString, Wrapper<RecipeDetail>>()
	let recipesListCache = NSCache<NSString, Wrapper<Recipes>>()
	
	private init() {}
	
	private let host = "tasty.p.rapidapi.com"
	private let baseURL = "https://tasty.p.rapidapi.com/recipes/"
	
	#warning("Paste your API KEY to the TRDatabase.plist file. You can obtain your api key at https://rapidapi.com/apidojo/api/tasty/. If you already completed this step, you can delete this line in the source code.")
	
	private var api_key: String {
	  get {
		
		guard let filePath = Bundle.main.path(forResource: "TRDatabase-Info", ofType: "plist") else {
		  fatalError("Couldn't find file 'TRDatabase-Info.plist'.")
		}
		
		let plist = NSDictionary(contentsOfFile: filePath)
		guard let value = plist?.object(forKey: "API_KEY") as? String else {
		  fatalError("Couldn't find key API_KEY in TRDatabase-Info.")
		}
		return value
	  }
	}
	
	func getRecipe(for id: Int, completion: @escaping(Result<RecipeDetail, TRError>) -> Void) {
		let cacheKey = NSString(string: String(id))
		
		if let recipe = recipesCache.object(forKey: cacheKey) {
			completion(.success(recipe.value))
			return
		}
		
		let headers = [
			"x-rapidapi-host": host,
			"x-rapidapi-key": api_key
		]
		
		let endpoint = baseURL + "detail?id=" + String(id)
		
		guard let url = URL(string: endpoint) else {
			completion(.failure(.invalidEntry))
			return
		}

		var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90.0)
		
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = headers

		let session = URLSession.shared
		
		let task = session.dataTask(with: request) { [weak self] (data, response, error) in
			guard let self = self else { return }
			
			if let _ = error {
				completion(.failure(.unableToComplete))
				return
			}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
				completion(.failure(.invalidResponse))
				return
			}
			
			guard let data = data else {
				dump(data, name: "Caught in guard block")
				completion(.failure(.invalidData))
				return
			}
			
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			
			do {
				let recipe = try decoder.decode(RecipeDetail.self, from: data)
				self.recipesCache.setObject(Wrapper(recipe), forKey: cacheKey)
				dump(self.recipesCache, name: "Recipes cache current value")
				completion(.success(recipe))
			} catch {
				dump(data, name: "Caught in catch block")
				completion(.failure(.invalidData))
			}
			
		}

		task.resume()
	}
	
	func downloadImage(from url: String, completion: @escaping(UIImage?) -> Void) {
		let cacheKey = NSString(string: url)
		
		if let image = imagesCache.object(forKey: cacheKey) {
			completion(image)
			return
		}
		
		guard let url = URL(string: url) else {
			completion(nil)
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			
			guard let self = self,
				error == nil,
				let response = response as? HTTPURLResponse, response.statusCode == 200,
				let data = data,
				let image = UIImage(data: data) else {
					completion(nil)
					return
				}
			
			self.imagesCache.setObject(image, forKey: cacheKey)
			completion(image)
		}
		
		task.resume()
	}
	
	func getRecipesList(for term: String, page: Int, completion: @escaping(Result<Recipes, TRError>) -> Void) {
		let cacheKey = NSString(string: String(term))
		
		if let recipes = recipesListCache.object(forKey: cacheKey) {
			completion(.success(recipes.value))
			return
		}
		
		let headers = [
			"x-rapidapi-host": host,
			"x-rapidapi-key": api_key
		]
		
		let resultsPerPage = 50
		
		let start = (page * resultsPerPage) - resultsPerPage
		
		let convertedTerm = term.lowercased().replacingOccurrences(of: " ", with: "%20")
		
		let endpoint = baseURL + "list?from=\(start)&size=\(resultsPerPage)&q=" + convertedTerm
		
		guard let url = URL(string: endpoint) else {
			completion(.failure(.invalidEntry))
			return
		}

		var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90.0)
		
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = headers

		let session = URLSession.shared
		
		let task = session.dataTask(with: request) { [weak self] (data, response, error) in
			guard let self = self else { return }
			
			if let _ = error {
				completion(.failure(.unableToComplete))
				return
			}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
				completion(.failure(.invalidResponse))
				return
			}
			
			guard let data = data else {
				completion(.failure(.invalidData))
				return
			}
			
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			
			do {
				let recipes = try decoder.decode(Recipes.self, from: data)
				self.recipesListCache.setObject(Wrapper(recipes), forKey: cacheKey)
				completion(.success(recipes))
			} catch {
				completion(.failure(.invalidData))
			}
			
		}

		task.resume()
	}
	
	
}
