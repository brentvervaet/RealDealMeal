//
//  MealListView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 12/08/2025.
//

//TODO: add categories underneath the search bar, then give a list of those meals (kindof a filter)

import SwiftUI

struct MealListView: View {
	// MARK: - Properties
	
	@StateObject private var mealListVM = MealListViewModel()
	private typealias Category = MealCategory
	
	// MARK: - Body
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				searchBar
				categoryList
				contentView
			}
			.navigationTitle("Find a recipe")
		}
	}
	
	// MARK: - Private Views
	
	/// Search bar with text field and submit action
	private var searchBar: some View {
		HStack {
			TextField("Search meals...", text: $mealListVM.searchQuery)
				.submitLabel(.search)
				.onSubmit {
					// Reset selectedCategory when performing a search
					mealListVM.selectedCategory = nil
					Task { await mealListVM.searchMeals() }
				}
				.padding(10)
				.background(Color(.systemBackground))
				.cornerRadius(Style.cornerRadius)
				.shadow(color: Color.black.opacity(0.1), radius: Style.shadowRadius, x: 0, y: 2)
		}
		.padding(.horizontal)
		.padding(.top)
	}
	
	/// Horizontally scrollable list of categories as selectable buttons
	private var categoryList: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(mealListVM.categories) { category in
					categoryButton(for: category)
				}
			}
			.padding(.horizontal)
			.onAppear {
				Task { await mealListVM.loadCategories() }
			}
		}
	}
	
	/// Button view for a meal category
	private func categoryButton(for category: Category) -> some View {
		Button {
			// When a category is selected, clear the search query and set the category
			mealListVM.searchQuery = ""
			Task { await mealListVM.loadMealsByCategory(category) }
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
	
	/// Main content view showing either error message or list of meals
	@ViewBuilder
	private var contentView: some View {
		if let errorMessage = mealListVM.errorMessage {
			Text(errorMessage)
				.foregroundColor(.red)
				.padding()
		} else {
			mealList
		}
	}
	
	/// Scrollable list of meals with navigation links to detail views
	private var mealList: some View {
		ScrollView {
			LazyVStack(spacing: 12) {
				ForEach(mealListVM.meals) { meal in
					NavigationLink(destination: MealDetailWrapperView(mealID: meal.idMeal)) {
						mealRow(for: meal)
					}
				}
			}
			.padding()
		}
	}
	
	/// Single row view representing a meal in the list
	private func mealRow(for meal: Meal) -> some View {
		HStack(spacing: 16) {
			AsyncImage(url: URL(string: meal.strMealThumb)) { image in
				image.resizable()
					.scaledToFill()
			} placeholder: {
				Color.gray.opacity(0.3)
			}
			.frame(width: 80, height: 80)
			.clipShape(RoundedRectangle(cornerRadius: Style.cornerRadius))
			
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
		.cornerRadius(Style.cornerRadius)
		.overlay(
			RoundedRectangle(cornerRadius: Style.cornerRadius)
				.stroke(Color.gray.opacity(0.1))
		)
		.shadow(color: Color.black.opacity(0.1), radius: Style.shadowRadius, x: 0, y: 2)
	}
	
	// MARK: - Style Constants
	
	private enum Style {
		static let cornerRadius: CGFloat = 12
		static let shadowRadius: CGFloat = 4
	}
}

struct MealDetailWrapperView: View {
	// MARK: - Properties
	
	let mealID: String
	@State private var meal: Meal? = nil
	@State private var isLoading = true
	@State private var errorMessage: String? = nil
	
	// MARK: - Body
	
	var body: some View {
		Group {
			if isLoading {
				ProgressView("Loading details...")
			} else if let meal = meal {
				MealDetailView(meal: meal)
			} else if let errorMessage = errorMessage {
				Text(errorMessage)
					.foregroundColor(.red)
			}
		}
		.task {
			await loadDetails()
		}
		.navigationTitle("Details")
		.navigationBarTitleDisplayMode(.inline)
	}
	
	// MARK: - Private Methods
	
	/// Loads detailed meal information asynchronously
	private func loadDetails() async {
		do {
			isLoading = true
			meal = try await APIService.shared.fetchMealDetail(id: mealID)
			errorMessage = nil
		} catch {
			errorMessage = "Failed to load details"
		}
		isLoading = false
	}
}

#Preview {
	MealListView()
}
