//
//  HomeViewModel.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
	@Published var dailyMeals: [Meal] = []
	@Published var isLoading = false
	
	func fetchDailyMeals() async {
		isLoading = true
		dailyMeals.removeAll()
		do {
			var meals: [Meal] = []
			for _ in 0..<4 {
				if let meal = try await fetchRandomMeal() {
					meals.append(meal)
				}
			}
			dailyMeals = meals
		} catch {
			print("Error fetching daily meals: \(error)")
		}
		isLoading = false
	}
	
	func fetchRandomMeal() async throws -> Meal? {
		guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php") else {
			throw URLError(.badURL)
		}
		let (data, _) = try await URLSession.shared.data(from: url)
		let response = try JSONDecoder().decode(MealResponse.self, from: data)
		return response.meals?.first
	}
}
