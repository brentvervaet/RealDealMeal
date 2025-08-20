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
				Text("No favorites yet ⭐")
					.foregroundColor(.secondary)
					.padding()
			} else {
				List(favoritesVM.favorites) { meal in
					NavigationLink(destination: MealDetailView(meal: meal)) {
						HStack {
							AsyncImage(url: URL(string: meal.strMealThumb)) { image in
								image.resizable()
									 .scaledToFill()
							} placeholder: {
								Color.gray.opacity(0.3)
							}
							.frame(width: 60, height: 60)
							.clipShape(RoundedRectangle(cornerRadius: 8))
							
							Text(meal.strMeal)
								.font(.headline)
						}
					}
				}
				//TODO: title needs to stay even when no favorites
				.navigationTitle("Favorites")
			}
		}
	}
}
