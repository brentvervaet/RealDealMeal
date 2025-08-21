//
//  HomeView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import SwiftUI

struct HomeView: View {
	@StateObject private var homeVM = HomeViewModel()
	
	var body: some View {
		NavigationStack {
			VStack {
				if homeVM.recommendedMeals.isEmpty {
					ProgressView("Loading recommended recipes...")
				} else {
					LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
						ForEach(homeVM.recommendedMeals) { meal in
							NavigationLink(destination: MealDetailWrapperView(mealID: meal.idMeal)) {
								VStack {
									AsyncImage(url: URL(string: meal.strMealThumb)) { image in
										image
											.resizable()
											.scaledToFill()
											.frame(width: 150, height: 150)
											.clipped()
											.cornerRadius(10)
									} placeholder: {
										Color.gray.opacity(0.3)
											.frame(width: 150, height: 150)
											.cornerRadius(10)
									}
									Text(meal.strMeal)
										.font(.caption)
										.multilineTextAlignment(.center)
										.padding(.top, 4)
								}
							}
						}
					}
					.padding()
				}
			}
			.task {
				await homeVM.loadRecommendedMeals()
			}
			.background(Color(.systemBackground))
			.background(Color(.systemGroupedBackground).ignoresSafeArea())
			.navigationTitle("Home")
		}
	}
}

#Preview {
	HomeView()
}
