//
//  MealCategory.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import Foundation

struct CategoryResponse: Codable {
	let meals: [MealCategory]
}

struct MealCategory: Codable, Identifiable, Hashable {
	let strCategory: String
	
	var id: String { strCategory }
}
