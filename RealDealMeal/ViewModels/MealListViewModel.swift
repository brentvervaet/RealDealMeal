//
//  MealListViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import Foundation

@MainActor
class MealListViewModel: ObservableObject {
	
	// MARK: - Typealiases
	typealias Category = MealCategory
	
	// MARK: - Published Properties
	@Published var meals: [Meal] = []
	@Published var searchQuery: String = ""
	@Published var isLoading = false
	@Published var errorMessage: String? = nil
	
	@Published var categories: [Category] = []
	@Published var selectedCategory: Category?
	
	// MARK: - Public Methods
	
	/// Searches for meals matching the current search query.
	func searchMeals() async {
		guard !searchQuery.isEmpty else { return }
		isLoading = true
		errorMessage = nil
		
		defer { isLoading = false }
		
		do {
			let results = try await APIService.shared.fetchMeals(query: searchQuery)
			meals = results
		} catch {
			errorMessage = "Failed to load meals: \(error.localizedDescription)"
		}
	}
	
	/// Loads the list of meal categories.
	func loadCategories() async {
		do {
			let fetchedCategories = try await APIService.shared.fetchCategories()
			categories = fetchedCategories
		} catch {
			print("Error fetching categories: \(error)")
		}
	}
	
	/// Fetches meals for the specified category.
	/// - Parameter category: The meal category to filter by.
	func fetchMealsByCategory(_ category: Category) async {
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
