//
//  Meal.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import Foundation

struct MealResponse: Codable {
	let meals: [Meal]?
}

struct Meal: Codable, Identifiable {
	let idMeal: String
	let strMeal: String
	let strMealThumb: String
	let strInstructions: String?
	
	var id: String { idMeal }
}
