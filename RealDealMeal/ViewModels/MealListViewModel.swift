//
//  MealListViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import SwiftUI

@MainActor
class MealListViewModel: ObservableObject {
	/// Searches for meals matching the current search query.
	// Task used for the current search
	private var searchTask: Task<Void, Never>?

	// MARK: - Published Properties
	@Published var meals: [Meal] = []
	@Published var searchQuery: String = ""
	@Published var isLoading = false
	@Published var errorMessage: String?

	@Published var categories: [MealCategory] = []
	@Published var selectedCategory: MealCategory?

	// MARK: - Dependencies
	private let service: APIServiceType

	// MARK: - Init
	init(service: APIServiceType = APIService.shared) {
		self.service = service
	}

	// MARK: - Public Methods

	/// Public entry point to start a debounced search. Cancels prior task if active.
	func searchMeals() {
		// Avoid creating a search for empty queries
		guard !searchQuery.isEmpty else { return }

		// Cancel previous search task
		searchTask?.cancel()

		// Start new debounced task
		searchTask = Task { [weak self] in
			// Debounce: wait 300ms before firing the network call
			try? await Task.sleep(nanoseconds: 300 * 1_000_000)
			guard let self else { return }
			await self.performSearch()
		}
	}

	/// Perform the actual search
	private func performSearch() async {
		guard !searchQuery.isEmpty else { return }
		isLoading = true
		errorMessage = nil

		defer { isLoading = false }

		do {
			// Allow cancellation to propagate
			try Task.checkCancellation()
			let results = try await service.fetchMeals(query: searchQuery)
			meals = results
		} catch is CancellationError {
			// canceled - ignore
		} catch {
			// Map APIError to a friendly message when possible
			if let apiError = error as? APIError {
				switch apiError {
				case .badURL:
					errorMessage = "Invalid search query. Try a different word."
				case .server:
					errorMessage = "Server error. Please try again later."
				case .decoding:
					errorMessage = "Unexpected response from server."
				case .transport:
					errorMessage = "Network error. Check your connection."
				}
			} else {
				errorMessage = "Failed to load meals: \(error.localizedDescription)"
			}
		}
	}

	/// Loads the list of meal categories.
	func loadCategories() async {
		do {
			let fetchedCategories = try await service.fetchCategories()
			categories = fetchedCategories
		} catch {
			print("Error fetching categories: \(error)")
		}
	}

	/// Fetches full meals for the specified category using APIService.
	func loadMealsByCategory(_ category: MealCategory) async {
		isLoading = true
		errorMessage = nil
		defer { isLoading = false }

		do {
			let fullMeals = try await service.fetchMealsByCategory(category.strCategory)
			meals = fullMeals
		} catch {
			errorMessage = "Error fetching meals by category: \(error.localizedDescription)"
			print(error)
		}
	}
}

// MARK: - ViewState
/*enum ViewState {
	case idle
	case loading
	case loaded
	case error(String)
}*/
