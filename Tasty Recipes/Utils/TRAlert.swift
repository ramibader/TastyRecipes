//
//  TRAlert.swift
//  Tasty Recipes
//
//  Created by Dominik Grodl on 12.09.2021.
//

import UIKit

struct TRAlert {
	
	private static func showAlert(on vc: UIViewController, title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		DispatchQueue.main.async { vc.present(alert, animated: true) }
	}
	
	static func presentErrorAlert(on vc: UIViewController, error: TRError) {
		showAlert(on: vc, title: "Something went wrong", message: error.rawValue)
	}
	
	static func presentAlert(on vc: UIViewController, title: String, message: String) {
		showAlert(on: vc, title: title, message: message)
	}
	
}
