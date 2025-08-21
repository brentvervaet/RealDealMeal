//
//  MealDetailView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 15/08/2025.
//

import SwiftUI

/// Displays detailed information about a meal, including image, title, ingredients, and instructions.
struct MealDetailView: View {
	// MARK: - Typealiases
	/// IngredientRow is a view representing a single ingredient line.
	private typealias IngredientRow = IngredientRowView

	// MARK: - Properties
	let meal: Meal
	@EnvironmentObject var favoritesVM: FavoritesViewModel

	// MARK: - Body
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				mealImage
				titleAndButtons
				detailCard
			}
			.padding()
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
			Color.gray.opacity(0.3)
		}
		.clipShape(RoundedRectangle(cornerRadius: 12))
		.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
		.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
	}

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
			guard let url = URL(string: meal.strMealThumb ?? "") else { return }
			let activityItems: [Any] = ["Check out this recipe from RealDealMeal: \(meal.strMeal)", url]
			let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
			if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			   let rootVC = windowScene.windows.first?.rootViewController {
				rootVC.present(activityVC, animated: true)
			}
		} label: {
			Image(systemName: "square.and.arrow.up")
				.font(.title2)
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
		.clipShape(RoundedRectangle(cornerRadius: 12))
		.background(.ultraThinMaterial)
		.overlay(
			RoundedRectangle(cornerRadius: 12)
				.stroke(.gray.opacity(0.1))
		)
		.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
				ForEach(meal.ingredients.indices, id: \.self) { idx in
					IngredientRow(ingredient: meal.ingredients[idx])
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
			ForEach(Array(meal.instructionSteps.enumerated()), id: \.offset) { idx, step in
				InstructionStepRow(index: idx, step: step)
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
}
