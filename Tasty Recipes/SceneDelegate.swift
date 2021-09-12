//
//  SceneDelegate.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let wScene = (scene as? UIWindowScene) else { return }
		
		window = UIWindow(frame: wScene.coordinateSpace.bounds)
		window?.windowScene = wScene
		window?.rootViewController = createTabBar()
		window?.makeKeyAndVisible()
	}
	
	func createTabBar() -> UITabBarController {
		
		UITabBar.appearance().tintColor = .systemPurple
		
		let tabBar = UITabBarController()
		
		tabBar.viewControllers = [createSearchNC(), createFavoritesNC()]
		
		return tabBar
	}
	
	func createSearchNC() -> UINavigationController {
		
		UINavigationBar.appearance().tintColor = .systemPurple
		
		let search = SearchVC()
		search.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
		
		return UINavigationController(rootViewController: search)
	}
	
	func createFavoritesNC() -> UINavigationController {
		
		let favorites = FavoritesListVC()
		favorites.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
		
		return UINavigationController(rootViewController: favorites)
		
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		
	}

	func sceneWillResignActive(_ scene: UIScene) {
		
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		
	}


}

