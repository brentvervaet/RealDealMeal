//
//  APIService.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import Foundation

class APIService {
	static let shared = APIService()
	private init() {}
	
	func fetchMeals(query: String) async throws -> [Meal] {
		guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)") else {
			throw URLError(.badURL)
		}
		
		let (data, _) = try await URLSession.shared.data(from: url)
		let response = try JSONDecoder().decode(MealResponse.self, from: data)
		return response.meals ?? []
	}
	
	func fetchCategories() async throws -> [MealCategory] {
		guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?c=list") else {
			throw URLError(.badURL)
		}
		
		let (data, _) = try await URLSession.shared.data(from: url)
		let response = try JSONDecoder().decode(CategoryResponse.self, from: data)
		return response.meals
	}
}
