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
			VStack(alignment: .leading, spacing: 8) {
				Text("Recommendations")
					.font(.title2)
					.bold()
					.padding(.horizontal)
				mealGrid
					.padding(.horizontal)
				Button(action: {
					Task {
						await homeVM.loadRecommendedMeals()
					}
				}) {
					Text("Random Recipe")
						.font(.headline)
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.accentColor)
						.foregroundColor(.white)
						.cornerRadius(10)
						.padding(.horizontal)
				}
				.padding(.top, 8)
			}
			.task {
				await homeVM.loadRecommendedMeals()
			}
			.background(Color(.systemBackground))
			.background(Color(.systemGroupedBackground).ignoresSafeArea())
			.navigationTitle("Home")
		}
	}
	
	private var mealGrid: some View {
		LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
			ForEach(homeVM.recommendedMeals) { meal in
				NavigationLink(destination: MealDetailWrapperView(mealID: meal.idMeal)) {
					MealCard(meal: meal)
				}
			}
		}
	}
}

struct MealCard: View {
	let meal: Meal
	
	var body: some View {
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

#Preview {
	HomeView()
}
