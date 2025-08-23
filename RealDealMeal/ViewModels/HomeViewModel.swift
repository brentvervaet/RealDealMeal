//
//  HomeViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 21/08/2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
	
	// MARK: - Typealiases
	typealias Meals = [Meal]
	
	// MARK: - Published Properties
	@Published var recommendedMeals: Meals = []
	@Published var isLoading = false
	@Published var errorMessage: String?
	@Published var randomMeal: Meal?
	
	// MARK: - Constants
	private let recommendedMealCount = 9
	
	// MARK: - Public Functions
	
	/// Loads recommended meals asynchronously and updates the published properties accordingly.
	func loadRecommendedMeals() async {
		isLoading = true
		defer { isLoading = false }
		
		do {
			recommendedMeals = try await fetchMultipleRandomMeals(count: recommendedMealCount)
			errorMessage = nil
		} catch {
			errorMessage = "Failed to load daily meals: \(error.localizedDescription)"
		}
	}
	
	/// Loads a single random meal asynchronously.
	/// - Returns: An optional `Meal` if fetching succeeds; otherwise, nil.
	func loadRandomMeal() async -> Meal? {
		do {
			return try await APIService.shared.fetchRandomMeal()
		} catch {
			print("Failed to fetch random meal: \(error)")
			return nil
		}
	}
	
	// MARK: - Private Functions
	
	/// Fetches a specified number of random meals asynchronously.
	/// - Parameter count: The number of random meals to fetch.
	/// - Throws: Propagates any error thrown by the API service.
	/// - Returns: An array of fetched `Meal` objects.
	private func fetchMultipleRandomMeals(count: Int) async throws -> Meals {
		var meals: Meals = []
		while meals.count < count {
			if let meal = try await APIService.shared.fetchRandomMeal() {
				if !meals.contains(where: { $0.idMeal == meal.idMeal }) {
					meals.append(meal)
				}
			}
		}
		return meals
	}
}
