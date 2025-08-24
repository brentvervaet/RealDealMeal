//
//  MealCategory.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import Foundation

// MARK: - API Response Models
/// Response wrapper for meal categories from TheMealDB API.
/// ViewModels call the APIService which decodes into this structure.
struct CategoryResponse: Codable {
	let meals: [MealCategory]
}

/// Represents a single meal category fetched from TheMealDB API.
/// Used by `MealListViewModel` to show selectable categories in the UI.
struct MealCategory: Codable, Identifiable, Hashable {
	
	let strCategory: String
	var id: String { strCategory }
	var name: String { strCategory }
}

// MARK: - Typealiases
typealias Category = MealCategory
