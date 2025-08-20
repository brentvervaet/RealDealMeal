//
//  FavoritesViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import SwiftUI

@MainActor
class FavoritesViewModel: ObservableObject {
	@AppStorage("favoriteMeals") private var favoriteMealsData: Data = Data()
	@Published private(set) var favorites: [Meal] = []
	
	func isFavorite(_ meal: Meal) -> Bool {
		favorites.contains { $0.idMeal == meal.idMeal }
	}
	
	func toggleFavorite(_ meal: Meal) {
		if isFavorite(meal) {
			favorites.removeAll { $0.idMeal == meal.idMeal }
		} else {
			favorites.append(meal)
		}
		saveFavorites()
	}
	
	private func saveFavorites() {
		if let data = try? JSONEncoder().encode(favorites) {
			favoriteMealsData = data
		}
	}
	
	init() {
		if let decoded = try? JSONDecoder().decode([Meal].self, from: favoriteMealsData) {
			favorites = decoded
		}
	}
}
