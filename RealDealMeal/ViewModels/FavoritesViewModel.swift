//
//  FavoritesViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import SwiftUI

/// Typealias for array of Meal objects, representing a favorites list.
typealias MealFavorites = [Meal]

/// ViewModel to manage favorite meals, using @AppStorage for persistence.
@MainActor
final class FavoritesViewModel: ObservableObject {
	// MARK: - Properties

	@AppStorage("favoriteMeals") private var favoriteMealsData: Data = Data()
	@Published private(set) var favorites: MealFavorites = []

	// MARK: - Initialization

	init() {
		loadFavorites()
	}

	// MARK: - Public Methods

	/// Checks if a meal is in the favorites list.
	/// - Parameter meal: The meal to check.
	/// - Returns: True if the meal is a favorite.
	func isFavorite(_ meal: Meal) -> Bool {
		favorites.contains { $0.idMeal == meal.idMeal }
	}

	/// Toggles the favorite status for a meal. If adding, adds the full meal directly.
	/// - Parameter meal: The meal to add or remove from favorites.
	@MainActor
	func toggleFavorite(_ meal: Meal) async {
		if isFavorite(meal) {
			removeFavorite(meal)
		} else {
			addFavorite(meal)
		}
		saveFavorites()
	}

	// MARK: - Private Methods

	/// Loads favorites from AppStorage.
	private func loadFavorites() {
		if let decoded = try? JSONDecoder().decode(MealFavorites.self, from: favoriteMealsData) {
			favorites = decoded
		} else {
			favorites = []
		}
	}

	/// Saves the current favorites to AppStorage.
	private func saveFavorites() {
		if let data = try? JSONEncoder().encode(favorites) {
			favoriteMealsData = data
		}
	}

	/// Removes a meal from favorites.
	/// - Parameter meal: The meal to remove.
	private func removeFavorite(_ meal: Meal) {
		favorites.removeAll { $0.idMeal == meal.idMeal }
	}

	/// Adds a meal to favorites.
	/// - Parameter meal: The meal to add.
	private func addFavorite(_ meal: Meal) {
		favorites.append(meal)
	}
}
