//
//  MealDetailView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 15/08/2025.
//

import SwiftUI

struct MealDetailView: View {
	let meal: Meal
	@EnvironmentObject var favoritesVM: FavoritesViewModel
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				AsyncImage(url: URL(string: meal.strMealThumb)) { image in
					image.resizable()
						.scaledToFit()
				} placeholder: {
					Color.gray.opacity(0.3)
				}
				.clipShape(RoundedRectangle(cornerRadius: 12))
				.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
				
				HStack {
					Text(meal.strMeal)
						.font(.largeTitle)
						.fontWeight(.bold)
					Spacer()
					Button {
						favoritesVM.toggleFavorite(meal)
					} label: {
						Image(systemName: favoritesVM.isFavorite(meal) ? "star.fill" : "star")
							.foregroundColor(.yellow)
							.font(.title2)
					}
				}
				
				VStack(alignment: .leading) {
					VStack(alignment: .leading, spacing: 8) {
						Text("Ingredients")
							.font(.title)
							.fontWeight(.semibold)
						LazyVStack(alignment: .leading, spacing: 4) {
							ForEach(meal.ingredients, id: \.ingredient) { item in
								HStack(alignment: .top, spacing: 6) {
									Text("•")
									Text(item.measure).bold() + Text(" \(item.ingredient)")
								}
							}
						}
					}
					
					if !meal.instructionSteps.isEmpty {
						Divider()
						
						VStack(alignment: .leading, spacing: 8) {
							Text("Instructions")
								.font(.title)
								.fontWeight(.semibold)
							ForEach(Array(meal.instructionSteps.enumerated()), id: \.offset) { index, step in
								HStack(alignment: .top, spacing: 6) {
									Text("Step \(index + 1).")
										.bold()
									Text(step)
										.font(.body)
										.multilineTextAlignment(.leading)
								}
							}
						}
					}
				}
				.padding()
				.background(Color(.systemBackground))
				.clipShape(RoundedRectangle(cornerRadius: 12))
				.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
			}
			.padding()
			//.background(Color(UIColor.secondarySystemBackground))
		}
		.navigationTitle(meal.strMeal)
		.navigationBarTitleDisplayMode(.inline)
	}
}
