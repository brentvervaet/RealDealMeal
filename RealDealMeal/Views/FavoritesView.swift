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
								HStack(spacing: Constants.Grid.spacing) {
									AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
										image.resizable()
											.scaledToFill()
									} placeholder: {
										Color.gray
											.opacity(
												Constants.Placeholder.opacity
											)
									}
									.frame(
										width: Constants.Row.Width,
										height: Constants.Row.Height
									)
									.clipShape(RoundedRectangle(cornerRadius: Constants.Corner.cornerRadiusS))

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
								.cornerRadius(Constants.Corner.cornerRadiusM)
								.overlay(
									RoundedRectangle(cornerRadius: Constants.Corner.cornerRadiusM)
										.stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
								)
								.shadow(
									color: Color.primary
										.opacity(
											Constants.Shadow.shadowOpacity
										),
									radius: 8,
									x: 0,
									y: 4
								)
								.frame(maxWidth: .infinity)

							}
							.padding(.horizontal)
						}
					}
					.padding(.vertical)
				}
				.navigationTitle("Favorites")
			}
		}
	}

}

// MARK: - Style Constants

private struct Constants {

	struct Corner {
		static let cornerRadiusS: CGFloat = 12
		static let cornerRadiusM: CGFloat = 16
		static let cornerRadiusL: CGFloat = 24
	}

	struct Shadow {
		static let shadowOpacity: CGFloat = 0.15
		static let shadowRadius: CGFloat = 10
		static let shadowX: CGFloat = 0
		static let shadowY: CGFloat = 5
	}

	struct Row {
		static let Width: CGFloat = 100
		static let Height
		: CGFloat = 100
	}

	struct Placeholder {
		static let opacity: CGFloat = 0.3
	}

	struct Grid {
		static let spacing: CGFloat = 16
	}

}
