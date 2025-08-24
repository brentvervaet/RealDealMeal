//
//  APIService.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import Foundation

// MARK: - API Errors
/// Errors raised by the network layer. ViewModels map these to user-friendly messages.
enum APIError: Error {
	case badURL
	case transport(Error)
	case server(statusCode: Int, data: Data?)
	case decoding(Error)
}

/// Protocol used by ViewModels so the service can be mocked in tests.
protocol APIServiceType {
	typealias MealResult = [Meal]
	typealias CategoryResult = [MealCategory]

	func fetchMeals(query: String) async throws -> MealResult
	func fetchCategories() async throws -> CategoryResult
	func fetchMealsByCategory(_ category: String) async throws -> [Meal]
	func fetchMealDetail(id: String) async throws -> Meal?
	func fetchRandomMeal() async throws -> Meal?
}


final class APIService: APIServiceType {
	// MARK: - Typealiases
	static let shared = APIService()
	private init() {}

	// Base URL for TheMealDB; acts as the Model/data layer.
	private let baseURL = "https://www.themealdb.com/api/json/v1/1/"
	private let decoder = JSONDecoder()
    
	// MARK: - Methods
    
	/// Fetch meals matching the query string. Called from `MealListViewModel`.
	/// - Parameter query: Search query string.
	/// - Returns: Array of `Meal` objects.
	func fetchMeals(query: String) async throws -> MealResult {
		// Percent-encode the query to avoid bad URL errors when user types quickly
		guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), !encoded.isEmpty else {
			return []
		}
		return try await fetch(endpoint: "search.php?s=\(encoded)", decodeTo: MealResponse.self)
			.meals ?? []
	}
	
	/// Fetch all meal categories.
	/// - Returns: Array of `MealCategory` objects.
	func fetchCategories() async throws -> CategoryResult {
		try await fetch(endpoint: "list.php?c=list", decodeTo: CategoryResponse.self)
			.meals
	}
	
	/// Fetch all meals by category using the centralized fetch helper.
	func fetchMealsByCategory(_ category: String) async throws -> [Meal] {
		try await fetch(endpoint: "filter.php?c=\(category)", decodeTo: MealResponse.self)
			.meals ?? []
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
	
	// MARK: - Private Helper
	/// Generic fetch method to retrieve and decode data from API with basic HTTP error handling.
	/// - Parameters:
	///   - endpoint: API endpoint path.
	///   - decodeTo: Decodable type to decode response into.
	/// - Returns: Decoded response object.
	/// ViewModels call this through the concrete methods above. Errors are intentionally
	/// propagated so ViewModels can decide how to present them to the user.
	private func fetch<T: Decodable>(endpoint: String, decodeTo: T.Type) async throws -> T {
		guard let url = URL(string: baseURL + endpoint) else { throw APIError.badURL }

		do {
			let (data, response) = try await URLSession.shared.data(from: url)
			guard let http = response as? HTTPURLResponse else {
				throw APIError.transport(URLError(.badServerResponse))
			}
			guard (200...299).contains(http.statusCode) else {
				throw APIError.server(statusCode: http.statusCode, data: data)
			}
			do {
				return try decoder.decode(T.self, from: data)
			} catch {
				throw APIError.decoding(error)
			}
		} catch is CancellationError {
			throw CancellationError()
		} catch {
			throw APIError.transport(error)
		}
	}
}
