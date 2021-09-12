//
//  TRError.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import Foundation

enum TRError: String, Error {
	case invalidEntry = "This entry created an invalid request. Please try again."
	case unableToComplete = "Unable to complete your request. Please check your internet connection"
	case invalidResponse = "Invalid response from the server. Please try again."
	case invalidData = "The data received from the server was invalid. Please try again."
	case unableToFavorite = "There was an error favoriting this recipe. Please try again."
	case alreadyInFavorites = "You've already favorited this recipe. You must REALLY like it!"
}
