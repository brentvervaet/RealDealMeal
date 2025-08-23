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
						
						randomRecipeButton
							.padding(.horizontal)
						
						
						
						// Adaptive grid based on screen width
						let columns = adaptiveColumns(for: bounds.size.width)
						
						LazyVGrid(columns: columns, spacing: Constants.Grid.spacing) {
							ForEach(homeVM.recommendedMeals) { meal in
								NavigationLink(destination: MealDetailWrapperView(mealID: meal.idMeal)) {
									MealCard(meal: meal)
										.frame(maxWidth: .infinity)
								}
							}
						}
						.padding(.horizontal)
					}
					.padding(.vertical)
				}
				
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
		if width > 600 {
			return Array(
				repeating: GridItem(.flexible(), spacing: Constants.Grid.spacing),
				count: 3
			)
		} else {
			return Array(repeating: GridItem(.flexible(), spacing: Constants.Grid.spacing), count: 2)
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
				.frame(maxWidth: Constants.Button.maxWidth)
				.padding()
				.background(Color(.systemBackground))
				.cornerRadius(Constants.Corner.cornerRadiusS)
				.cornerRadius(Constants.Corner.cornerRadiusM)
				.shadow(
					color: Color.black.opacity(Constants.Shadow.shadowOpacity),
					radius: Constants.Shadow.shadowRadius,
					x: Constants.Shadow.shadowX,
					y: Constants.Shadow.shadowY
				)				.frame(maxWidth: .infinity)
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
					.frame(maxWidth: Constants.Card.maxW, maxHeight: Constants.Card.maxH)
					.clipped()
					.cornerRadius(Constants.Corner.cornerRadiusM)
			} placeholder: {
				Color.gray.opacity(Constants.Placeholder.opacity)
					.frame(
						maxWidth: Constants.Placeholder.maxW,
						maxHeight: Constants.Placeholder.maxH
					)
					.cornerRadius(Constants.Corner.cornerRadiusM)
			}
			Text(meal.strMeal)
				.font(.caption)
				.multilineTextAlignment(.center)
				.padding(.top, 4)
		}
		.frame(maxWidth: .infinity)
		.padding(Constants.Card.inset)
		.background(.white)
		.cornerRadius(Constants.Corner.cornerRadiusM)
		.shadow(
			color: Color.black.opacity(Constants.Shadow.shadowOpacity),
			radius: Constants.Shadow.shadowRadius,
			x: Constants.Shadow.shadowX,
			y: Constants.Shadow.shadowY
		)
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
	
	struct Button {
		static let maxWidth: CGFloat = 500
	}
	
	struct Card {
		static let inset: CGFloat = 12
		static let maxW: CGFloat = 350
		static let maxH: CGFloat = 350
	}
	
	struct Placeholder {
		static let opacity: CGFloat = 0.3
		static let maxW: CGFloat = 350
		static let maxH: CGFloat = 350
	}
	
	struct Grid {
		static let spacing: CGFloat = 16
	}
	
}


#Preview {
	HomeView()
}
