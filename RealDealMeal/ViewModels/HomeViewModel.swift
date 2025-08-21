//
//  HomeViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 21/08/2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
	@Published var recommendedMeals: [Meal] = []
	@Published var isLoading: Bool = false
	@Published var errorMessage: String? = nil
	@Published var randomMeal: Meal?
	
	func loadRecommendedMeals() async {
		isLoading = true
		defer { isLoading = false }
		do {
			var meals: [Meal] = []
			for _ in 0..<4 {
				if let randomMeal = try await APIService.shared.fetchRandomMeal() {
					meals.append(randomMeal)
				}
			}
			recommendedMeals = meals
			errorMessage = nil
		} catch {
			errorMessage = "Failed to load daily meals: \(error.localizedDescription)"
		}
	}
	
	func loadRandomMeal() async -> Meal? {
		do {
			let meal = try await APIService.shared.fetchRandomMeal()
			return meal
		} catch {
			print("Failed to fetch random meal: \(error)")
			return nil
		}
	}
}
