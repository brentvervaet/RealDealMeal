//
//  HomeViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 21/08/2025.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
	
	// MARK: - Typealiases
	typealias Meals = [Meal]
	
	// MARK: - Published Properties
	@Published var recommendedMeals: Meals = []
	@Published var isLoading = false
	@Published var errorMessage: String?
	@Published var randomMeal: Meal?
	
	// MARK: - Dependencies
	private let service: APIServiceType

	// MARK: - Constants
	private let recommendedMealCount = 9

	// MARK: - Init
	init(service: APIServiceType = APIService.shared) {
		self.service = service
	}
	
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
			return try await service.fetchRandomMeal()
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
		var uniqueMeals: [String: Meal] = [:]

		try await withThrowingTaskGroup(of: Meal?.self) { group in
			// Start `count` child tasks in parallel
			for _ in 0..<count {
				group.addTask { [service] in
					try await service.fetchRandomMeal()
				}
			}

			for try await result in group {
				try Task.checkCancellation()
				if let meal = result {
					uniqueMeals[meal.idMeal] = meal
				}
				if uniqueMeals.count >= count {
					// Cancel remaining tasks when we've collected enough unique meals
					group.cancelAll()
					break
				}
			}
		}

		return Array(uniqueMeals.values)
	}
}
