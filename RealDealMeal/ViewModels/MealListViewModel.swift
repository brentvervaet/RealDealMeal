//
//  MealListViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import Foundation

@MainActor
class MealListViewModel: ObservableObject {
	@Published var meals: [Meal] = []
	@Published var searchQuery: String = ""
	@Published var isLoading = false
	@Published var errorMessage: String? = nil
	
	@Published var categories: [MealCategory] = []
	@Published var selectedCategory: MealCategory?
	
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
	
	func loadCategories() async {
		do {
			let catg = try await APIService.shared.fetchCategories()
			categories = catg
		} catch {
			print("Error fetching categories: \(error)")
		}
	}

	func fetchMealsByCategory(_ category: MealCategory) async {
		guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category.strCategory)") else { return }
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			let response = try JSONDecoder().decode(MealResponse.self, from: data)
			meals = response.meals ?? []
		} catch {
			print("Error fetching meals by category: \(error)")
		}
	}
}
