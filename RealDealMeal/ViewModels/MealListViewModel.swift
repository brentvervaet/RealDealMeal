//
//  MealListViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import Foundation

//@MainActor
class MealListViewModel: ObservableObject {
	@Published var meals: [Meal] = []
	@Published var searchQuery: String = ""
	@Published var isLoading = false
	@Published var errorMessage: String? = nil
	
	func searchMeals() async {
		guard !searchQuery.isEmpty else { return }
		isLoading = true
		errorMessage = nil
		do {
			let results = try await APIService.shared.fetchMeals(query: searchQuery)
			meals = results
		} catch {
			errorMessage = "Failed to load meals: \(error.localizedDescription)"
		}
		isLoading = false
	}
}
