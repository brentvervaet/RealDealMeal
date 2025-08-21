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
	
	/// Fetches full meals for the specified category using APIService.
	func loadMealsByCategory(_ category: Category) async {
		isLoading = true
		errorMessage = nil
		defer { isLoading = false }
		
		do {
			let fullMeals = try await APIService.shared.fetchMealsByCategory(category.strCategory)
			meals = fullMeals
		} catch {
			errorMessage = "Error fetching meals by category: \(error.localizedDescription)"
			print(error)
		}
	}
}
