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
			VStack(alignment: .leading) {
				searchBar
				categoryList
				if let errorMessage = mealListVM.errorMessage {
					Text(errorMessage)
						.foregroundColor(.red)
						.padding()
				} else {
					mealList
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
	
	private var categoryList: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(mealListVM.categories) { category in
					Button {
						Task { await mealListVM.fetchMealsByCategory(category) }
						mealListVM.selectedCategory = category
					} label: {
						Text(category.strCategory)
							.padding(.vertical, 8)
							.padding(.horizontal, 12)
							.background(
								mealListVM.selectedCategory == category ?
								Color.accentColor : Color(.systemGray5)
							)
							.foregroundColor(
								mealListVM.selectedCategory == category ?
									.white : .primary
							)
							.clipShape(Capsule())
					}
				}
			}
			.padding(.horizontal)
			.onAppear {
				Task { await mealListVM.loadCategories() }
			}
		}
	}
	
	private var mealList: some View {
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
	}
}

#Preview {
	MealListView()
}
