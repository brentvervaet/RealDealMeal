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
				
				titleAndButtons
				
				VStack(alignment: .leading) {
					ingredients
					Divider()
					instructions
				}
				.padding()
				.background(Color(.systemBackground))
				.clipShape(RoundedRectangle(cornerRadius: 12))
				.overlay(
					RoundedRectangle(
						cornerRadius: 12,
					)
					.stroke(.gray.opacity(0.1))
				)
				.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
			}
			.padding()
		}
		.navigationTitle(meal.strMeal)
		.navigationBarTitleDisplayMode(.inline)
	}
	
	private var titleAndButtons: some View {
		HStack {
			Text(meal.strMeal)
				.font(.largeTitle)
				.fontWeight(.bold)
			Spacer()
			Button {
				favoritesVM.toggleFavorite(meal)
			} label: {
				Image(systemName: favoritesVM.isFavorite(meal) ? "heart.fill" : "heart")
					.foregroundColor(.red)
					.font(.title2)
			}
			Button {
			} label: {
				Image(systemName: "square.and.arrow.up")
					.font(.title2)
			}
		}
		
	}
	
	private var ingredients: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Ingredients")
				.font(.title)
				.fontWeight(.semibold)
				.underline()
			LazyVStack(alignment: .leading, spacing: 4) {
				ForEach(meal.ingredients, id: \.ingredient) { item in
					HStack(alignment: .top, spacing: 6) {
						Text("•")
						Text(item.measure).bold() + Text(" \(item.ingredient)")
					}
				}
			}
			.padding(.vertical)
		}
	}
	
	private var instructions: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Instructions")
				.font(.title)
				.fontWeight(.semibold)
				.underline()
			ForEach(Array(meal.instructionSteps.enumerated()), id: \.offset) { index, step in
				HStack(alignment: .top, spacing: 6) {
					Text("Step \(index + 1).")
						.bold()
					Text(step)
						.font(.body)
						.multilineTextAlignment(.leading)
				}
			}
			.padding(.vertical)
		}
	}
}
