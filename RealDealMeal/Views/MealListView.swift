//
//  MealListView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 12/08/2025.
//

//TODO: add categories underneath the search bar, then give a list of those meals (kindof a filter)

import SwiftUI

struct MealListView: View {
	@StateObject private var mealListVM = MealListViewModel()
	
	var body: some View {
		NavigationStack {
			VStack {
				searchBar
				
				if let errorMessage = mealListVM.errorMessage {
					Text(errorMessage)
						.foregroundColor(.red)
						.padding()
				} else {
					ScrollView {
						LazyVStack(spacing: 12) {
							ForEach(mealListVM.meals) { meal in
								NavigationLink(destination: MealDetailView(meal: meal)) {
									HStack(spacing: 16) {
										AsyncImage(url: URL(string: meal.strMealThumb)) { image in
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
				}
			}
			.navigationTitle("Find a recipe")
		}
	}
	private var searchBar: some View {
		HStack {
			TextField("Search meals...", text: $mealListVM.searchQuery)
				.submitLabel(.search)
				.onSubmit {
					Task { await mealListVM.searchMeals() }
				}
				.padding(10)
				.background(Color(.systemBackground))
				.cornerRadius(12)
				.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
		}
		.padding(.horizontal)
		.padding(.top)
	}
}

#Preview {
	MealListView()
}
