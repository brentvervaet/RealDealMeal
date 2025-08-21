//
//  FavoritesView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import SwiftUI

struct FavoritesView: View {
	@EnvironmentObject var favoritesVM: FavoritesViewModel
	
	var body: some View {
		NavigationStack {
			if favoritesVM.favorites.isEmpty {
				Text("No favorites yet")
					.foregroundColor(.secondary)
					.padding()
			} else {
				ScrollView {
					LazyVStack(spacing: 12) {
						ForEach(favoritesVM.favorites) { meal in
							NavigationLink(destination: MealDetailView(meal: meal)) {
								HStack(spacing: 16) {
									AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
										image.resizable()
											.scaledToFill()
									} placeholder: {
										Color.gray.opacity(0.3)
									}
									.frame(width: 80, height: 80)
									.clipShape(RoundedRectangle(cornerRadius: 12))
									
									Text(meal.strMeal)
										.font(.headline)
										.foregroundColor(.primary)
									
									Spacer()
									Image(systemName: "chevron.right")
										.foregroundColor(.gray)
										.font(.system(size: 14, weight: .semibold))
								}
								.padding()
								.background(Color(.systemBackground))
								.cornerRadius(12)
								.overlay(
									RoundedRectangle(
										cornerRadius: 12,
									)
									.stroke(.gray.opacity(0.1))
								)
								.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
							}
						}
					}
					.padding()
				}
				.navigationTitle("Favorites")
			}
		}
	}
}


