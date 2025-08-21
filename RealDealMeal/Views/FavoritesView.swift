//
//  FavoritesView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import SwiftUI

struct FavoritesView: View {
	// MARK: - Typealias
	typealias FavoriteMeal = Meal
	
	// MARK: - Properties
	@EnvironmentObject private var favoritesVM: FavoritesViewModel
	
	var body: some View {
		NavigationStack {
			if favoritesVM.favorites.isEmpty {
				emptyStateView
			} else {
				favoritesListView
					.navigationTitle("Favorites")
			}
		}
	}
	
	// MARK: - Private Views
	
	/// View displayed when there are no favorites
	private var emptyStateView: some View {
		Text("No favorites yet")
			.foregroundColor(.secondary)
			.padding()
	}
	
	/// Scrollable list of favorite meals
	private var favoritesListView: some View {
		ScrollView {
			LazyVStack(spacing: 12) {
				ForEach(favoritesVM.favorites) { meal in
					favoriteMealRow(for: meal)
				}
			}
			.padding()
		}
	}
	
	/// Row view representing a single favorite meal
	/// - Parameter meal: The meal to display
	/// - Returns: A view representing the meal row
	private func favoriteMealRow(for meal: FavoriteMeal) -> some View {
		NavigationLink(destination: MealDetailView(meal: meal)) {
			HStack(spacing: 16) {
				AsyncImage(url: URL(string: meal.strMealThumb)) { image in
					image.resizable()
						.scaledToFill()
				} placeholder: {
					Color.gray.opacity(0.3)
				}
				.frame(width: 80, height: 80)
				.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
				
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
			.cornerRadius(Constants.cornerRadius)
			.overlay(
				RoundedRectangle(cornerRadius: Constants.cornerRadius)
					.stroke(Color.gray.opacity(0.1))
			)
			.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
		}
	}
	
	// MARK: - Constants
	
	private enum Constants {
		static let cornerRadius: CGFloat = 12
	}
}
