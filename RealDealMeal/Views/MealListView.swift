//
//  MealListView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 12/08/2025.
//

import SwiftUI

struct MealListView: View {
	
	@StateObject private var mealListVM = MealListViewModel()
	private typealias Category = MealCategory
	
	var body: some View {
		GeometryReader{ bounds in
			NavigationStack {
				VStack(alignment: .leading) {
					searchBar
					categoryList
					contentView
					
				}
				.navigationTitle("Find a recipe")
			}
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
					mealListVM.searchMeals()
				}
				.onChange(of: mealListVM.searchQuery) { _, newValue in
					// Live search: only start when user has typed at least 2 chars
					mealListVM.selectedCategory = nil
					if newValue.count >= 2 {
						mealListVM.searchMeals()
					}
				}
				.padding(10)
				.background(Color(.systemBackground))
				.cornerRadius(Constants.Corner.cornerRadiusS)
				.shadow(
					color: Color.primary.opacity(Constants.Shadow.shadowOpacity),
					radius: Constants.Shadow.shadowRadius ,
					x: Constants.Shadow.shadowX,
					y: Constants.Shadow.shadowY
				)
			
		}
		.padding(.horizontal)
		.padding(.top)
	}
	
	/// Horizontally scrollable list of categories as selectable buttons
	private var categoryList: some View {
		ScrollView(.horizontal, showsIndicators: false ) {
			HStack(spacing: 12) {
				ForEach(mealListVM.categories) { category in
					categoryButton(for: category)
				}
			}
			.padding()
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
					Color(.systemBackground) : .primary
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
			VStack(alignment: .leading, spacing: 8) {
				if !mealListVM.meals.isEmpty {
					Text("\(mealListVM.meals.count) results found")
						.font(.subheadline)
						.foregroundColor(.secondary)
						.padding(.horizontal)
				}
				mealList
			}
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
			AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
				image.resizable()
					.scaledToFill()
			} placeholder: {
				Color.gray.opacity(Constants.Placeholder.opacity)
			}
			.frame(width: Constants.Row.W, height: Constants.Row.H)
			.clipShape(
				RoundedRectangle(cornerRadius: Constants.Corner.cornerRadiusS)
			)
			
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
		.shadow(
			color: Color.primary.opacity(Constants.Shadow.shadowOpacity),
			radius: Constants.Shadow.shadowRadius,
			x: Constants.Shadow.shadowX,
			y: Constants.Shadow.shadowY
		)
		
	}
}

struct MealDetailWrapperView: View {
	
	let mealID: String
	@State private var meal: Meal? = nil
	@State private var isLoading = true
	@State private var errorMessage: String? = nil
	private let service: APIServiceType = APIService.shared
	
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
			meal = try await service.fetchMealDetail(id: mealID)
			errorMessage = nil
		} catch {
			errorMessage = "Failed to load details"
		}
		isLoading = false
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
		static let W: CGFloat = 100
		static let H: CGFloat = 100
	}
	
	struct Placeholder {
		static let opacity: CGFloat = 0.3
	}
	
	struct Grid {
		static let spacing: CGFloat = 16
	}
	
}

// MARK: - Preview

#Preview {
	MealListView()
}
