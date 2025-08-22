//
//  HomeView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import SwiftUI

struct HomeView: View {
	@StateObject private var homeVM = HomeViewModel()
	@State private var randomMealID: String? = nil
	@State private var showRandomMealDetail: Bool = false
	@State private var showInfo: Bool = false
	
	var body: some View {
		NavigationStack {
			GeometryReader { bounds in
				ScrollView {
					VStack(alignment: .leading, spacing: 16) {
						
						// Recommendations header
						HStack {
							Text("Recommendations")
								.font(.title2).bold()
							Spacer()
							Button {
								Task { await homeVM.loadRecommendedMeals() }
							} label: {
								Image(systemName: "arrow.clockwise")
							}
						}
						.padding(.horizontal)
						
						// Adaptive grid based on screen width
						let columns = adaptiveColumns(for: bounds.size.width)
						
						LazyVGrid(columns: columns, spacing: 16) {
							ForEach(homeVM.recommendedMeals) { meal in
								NavigationLink(destination: MealDetailWrapperView(mealID: meal.idMeal)) {
									MealCard(meal: meal)
										.frame(maxWidth: .infinity)
								}
							}
						}
						.padding(.horizontal)
						
						randomRecipeButton
							.padding(.horizontal)
					}
					.padding(.vertical)
				}
				.frame(width: bounds.size.width, height: bounds.size.height)
			}
			.navigationTitle("Home")
			.navigationDestination(isPresented: $showRandomMealDetail) {
				if let mealID = randomMealID {
					MealDetailWrapperView(mealID: mealID)
				}
			}
			.onAppear {
				if homeVM.recommendedMeals.isEmpty {
					Task { await homeVM.loadRecommendedMeals() }
				}
			}
			.toolbar {
				Button { showInfo = true } label: {
					Image(systemName: "info.circle")
				}
			}
			.sheet(isPresented: $showInfo) {
				InfoView()
			}
		}
	}
	
	/// Adjust number of columns depending on screen width
	private func adaptiveColumns(for width: CGFloat) -> [GridItem] {
		if width > 900 {
			return Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
		} else if width > 600 {
			return Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
		} else {
			return Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
		}
	}
	
	private var randomRecipeButton: some View {
		Button {
			Task {
				if let randomMeal = await homeVM.loadRandomMeal() {
					randomMealID = randomMeal.idMeal
					showRandomMealDetail = true
				}
			}
		} label: {
			Text("\(Image(systemName: "sparkles")) Random Recipe \(Image(systemName: "sparkles"))")
				.font(.headline)
				.frame(maxWidth: .infinity)
				.padding()
				.background(.ultraThinMaterial)
				.cornerRadius(12)
				.shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
		}
	}
}
struct MealCard: View {
	let meal: Meal
	
	var body: some View {
		VStack {
			AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
				image
					.resizable()
					.scaledToFill()
					.frame(width: 150, height: 150)
					.clipped()
					.cornerRadius(12)
			} placeholder: {
				Color.gray.opacity(0.3)
					.frame(width: 150, height: 150)
					.cornerRadius(12)
			}
			Text(meal.strMeal)
				.font(.caption)
				.multilineTextAlignment(.center)
				.padding(.top, 4)
		}
		.padding(8)
		.background(.ultraThinMaterial)
		.cornerRadius(20)
		.shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
	}
}

#Preview {
	HomeView()
}
