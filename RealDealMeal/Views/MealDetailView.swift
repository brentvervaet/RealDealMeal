//
//  MealDetailView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 15/08/2025.
//

import SwiftUI

struct MealDetailView: View {
	let meal: Meal
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				AsyncImage(url: URL(string: meal.strMealThumb)) { image in
					image.resizable()
						 .scaledToFit()
				} placeholder: {
					Color.gray.opacity(0.3)
				}
				.clipShape(RoundedRectangle(cornerRadius: 12))
				
				Text(meal.strMeal)
					.font(.title)
					.fontWeight(.bold)
				
				if let instructions = meal.strInstructions {
					Text(instructions)
						.font(.body)
						.multilineTextAlignment(.leading)
				}
			}
			.padding()
		}
		.navigationTitle(meal.strMeal)
		.navigationBarTitleDisplayMode(.inline)
	}
}
