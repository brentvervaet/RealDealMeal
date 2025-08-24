//
//  MealDetailView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 15/08/2025.
//

import SwiftUI
import UIKit

/// Displays detailed information about a meal, including image, title, ingredients, and instructions.
struct MealDetailView: View {
	
	// MARK: - Properties
	let meal: Meal
	@EnvironmentObject var favoritesVM: FavoritesViewModel
	@State private var showingShare = false
	@State private var shareItems: [Any] = []
	
	// MARK: - Body
	var body: some View {
		GeometryReader { bounds in
			ScrollView {
				if bounds.size.width > 700 { // wide screens → horizontal layout
					VStack{
						HStack(alignment: .bottom, spacing: 20) {
							mealImage
								.frame(width: min(bounds.size.width * 0.4, 400)) // max 400 wide
							titleAndButtons
						}
						detailCard
						
					}
					.padding()
					.frame(maxWidth: bounds.size.width * 0.8 )
					.frame(maxWidth: .infinity)
				} else { // iPhone or portrait
					VStack(alignment: .leading, spacing: 20) {
						mealImage
						titleAndButtons
						detailCard
					}
					.padding()
					.frame(maxWidth: 800)
					.frame(maxWidth: .infinity)
				}
			}
		}
		.navigationTitle(meal.strMeal)
		.navigationBarTitleDisplayMode(.inline)
	}
	// MARK: - Private Views
	
	/// The meal image with styling.
	private var mealImage: some View {
		AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
			image.resizable()
				.scaledToFit()
		} placeholder: {
			Color.gray.opacity(Constants.Placeholder.opacity)
		}
		.clipShape(
			RoundedRectangle(
				cornerRadius: Constants.Corner.cornerRadiusM,
			)
		)
		.shadow(
			color: Color.primary.opacity(Constants.Shadow.shadowOpacity),
			radius: Constants.Shadow.shadowRadius,
			x: Constants.Shadow.shadowX,
			y: Constants.Shadow.shadowY
		)	}
	
	/// The title and action buttons row.
	private var titleAndButtons: some View {
		HStack {
			Text(meal.strMeal)
				.font(.largeTitle)
				.fontWeight(.bold)
			Spacer()
			favoriteButton
			shareButton
		}
	}
	
	/// The favorite button.
	private var favoriteButton: some View {
		Button {
			Task {
				await favoritesVM.toggleFavorite(meal)
			}
		} label: {
			Image(systemName: favoritesVM.isFavorite(meal) ? "heart.fill" : "heart")
				.foregroundColor(.red)
				.font(.title2)
		}
	}
	
	/// The share button.
	private var shareButton: some View {
		Button {
			var items: [Any] = ["Check out this recipe from RealDealMeal: \(meal.strMeal)"]
			if let url = URL(string: meal.strMealThumb ?? "") { items.append(url) }
			shareItems = items
			showingShare = true
		} label: {
			Image(systemName: "square.and.arrow.up")
				.font(.title2)
		}
		.sheet(isPresented: $showingShare) {
			ShareSheet(activityItems: shareItems)
		}
	}
	
	/// The main detail card showing ingredients and instructions.
	private var detailCard: some View {
		VStack(alignment: .leading, spacing: 16) {
			if meal.ingredients.isEmpty && meal.instructionSteps.isEmpty {
				comingSoon
			} else {
				if !meal.ingredients.isEmpty {
					ingredientsSection
				}
				if !meal.ingredients.isEmpty && !meal.instructionSteps.isEmpty {
					Divider()
				}
				if !meal.instructionSteps.isEmpty {
					instructionsSection
				}
			}
		}
		.padding()
		.background(Color(.systemBackground))
		.clipShape(RoundedRectangle(cornerRadius: Constants.Corner.cornerRadiusM))
		.shadow(
			color: Color.primary.opacity(Constants.Shadow.shadowOpacity),
			radius: Constants.Shadow.shadowRadius,
			x: Constants.Shadow.shadowX,
			y: Constants.Shadow.shadowY
		)
	}
	
	/// Placeholder view for missing meal details.
	private var comingSoon: some View {
		HStack {
			Spacer()
			Text("Coming soon...")
				.foregroundColor(.secondary)
				.italic()
			Spacer()
		}
		.frame(maxWidth: .infinity)
	}
	
	/// The ingredients section.
	private var ingredientsSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Ingredients")
				.font(.title)
				.fontWeight(.semibold)
				.underline()
			LazyVStack(alignment: .leading, spacing: 4) {
				ForEach(Array(meal.ingredients.enumerated()), id: \.offset) {
					IngredientRow(ingredient: $0.element)
				}
			}
			.padding(.vertical)
		}
	}
	
	/// The instructions section.
	private var instructionsSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Instructions")
				.font(.title)
				.fontWeight(.semibold)
				.underline()
			ForEach(Array(meal.instructionSteps.enumerated()), id: \.offset) {
				InstructionStepRow(index: $0.offset, step: $0.element)
			}
			.padding(.vertical)
		}
	}
	
	// MARK: - Row Views
	/// Displays a single ingredient row.
	private struct IngredientRowView: View {
		let ingredient: Meal.Ingredient
		var body: some View {
			HStack {
				Text("•")
				Text(ingredient.measure).bold() + Text(" \(ingredient.ingredient)")
			}
		}
	}
	
	/// Displays a single instruction step row.
	private struct InstructionStepRow: View {
		let index: Int
		let step: String
		var body: some View {
			HStack(alignment: .top, spacing: 6) {
				Text("Step \(index + 1).")
					.bold()
				Text(step)
					.font(.body)
					.multilineTextAlignment(.leading)
			}
		}
	}
	
	// MARK: - Typealiases
	/// IngredientRow is a view representing a single ingredient line.
	private typealias IngredientRow = IngredientRowView
	
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
			static let shadowX: CGFloat = 1
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
}

// MARK: - ShareSheet

/// Lightweight wrapper to present a UIActivityViewController from SwiftUI.
private struct ShareSheet: UIViewControllerRepresentable {
	let activityItems: [Any]

	func makeUIViewController(context: Context) -> UIActivityViewController {
		UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
