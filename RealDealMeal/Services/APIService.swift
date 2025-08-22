//
//  APIService.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import Foundation

class APIService {
	// MARK: - Typealiases
	typealias MealResult = [Meal]
	typealias CategoryResult = [MealCategory]
	
	// MARK: - Properties
	static let shared = APIService()
	private init() {}
	
	private let baseURL = "https://www.themealdb.com/api/json/v1/1/"
	private let decoder = JSONDecoder()
	
	// MARK: - Methods
	
	/// Fetch meals matching the query string.
	/// - Parameter query: Search query string.
	/// - Returns: Array of `Meal` objects.
	func fetchMeals(query: String) async throws -> MealResult {
		try await fetch(endpoint: "search.php?s=\(query)", decodeTo: MealResponse.self)
			.meals ?? []
	}
	
	/// Fetch all meal categories.
	/// - Returns: Array of `MealCategory` objects.
	func fetchCategories() async throws -> CategoryResult {
		try await fetch(endpoint: "list.php?c=list", decodeTo: CategoryResponse.self)
			.meals
	}
	
	/// Fetch all meals by category, and upgrade them to full meals using lookup.
	func fetchMealsByCategory(_ category: String) async throws -> [Meal] {
		// Stap 1: haal de "lichte" meals op
		guard let url = URL(string: baseURL + "filter.php?c=\(category)") else {
			throw URLError(.badURL)
		}
		let (data, _) = try await URLSession.shared.data(from: url)
		let response = try decoder.decode(MealResponse.self, from: data)
		let lightMeals = response.meals ?? []
		
		return lightMeals
	}
	
	/// Fetch detailed information for a meal by ID.
	/// - Parameter id: Meal identifier.
	/// - Returns: Optional `Meal` object.
	func fetchMealDetail(id: String) async throws -> Meal? {
		try await fetch(endpoint: "lookup.php?i=\(id)", decodeTo: MealResponse.self)
			.meals?.first
	}
	
	/// Fetch a random meal.
	/// - Returns: Optional `Meal` object.
	func fetchRandomMeal() async throws -> Meal? {
		try await fetch(endpoint: "random.php", decodeTo: MealResponse.self)
			.meals?.first
	}
	
	// MARK: - Private Helper
	
	/// Generic fetch method to retrieve and decode data from API.
	/// - Parameters:
	///   - endpoint: API endpoint path.
	///   - decodeTo: Decodable type to decode response into.
	/// - Returns: Decoded response object.
	private func fetch<T: Decodable>(endpoint: String, decodeTo: T.Type) async throws -> T {
		guard let url = URL(string: baseURL + endpoint) else {
			throw URLError(.badURL)
		}
		let (data, _) = try await URLSession.shared.data(from: url)
		return try decoder.decode(T.self, from: data)
	}
}
