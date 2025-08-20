//
//  MealListView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 12/08/2025.
//

import SwiftUI

struct MealListView: View {
	@StateObject private var mealListVM = MealListViewModel()
	
	var body: some View {
		NavigationStack {
			VStack {
				HStack {
					TextField("Search meals...", text: $mealListVM.searchQuery)
						.textFieldStyle(.roundedBorder)
						.submitLabel(.search)
						.onSubmit {
							Task { await mealListVM.searchMeals() }
						}
				}
				.padding()
				
				if mealListVM.isLoading {
					ProgressView("Loading...")
						.padding()
				} else if let errorMessage = mealListVM.errorMessage {
					Text(errorMessage)
						.foregroundColor(.red)
						.padding()
				} else {
					List(mealListVM.meals) { meal in
						NavigationLink(destination: MealDetailView(meal: meal)) {
							HStack {
								AsyncImage(url: URL(string: meal.strMealThumb)) { image in
									image.resizable()
										.scaledToFill()
								} placeholder: {
									Color.gray.opacity(0.3)
								}
								.frame(width: 80, height: 80)
								.clipShape(RoundedRectangle(cornerRadius: 8))
								
								Text(meal.strMeal)
									.font(.headline)
							}
						}
					}
				}
			}
			.navigationTitle("Find recipe")//Recipe finder
			
		}
	}
}

#Preview {
	MealListView()
}
