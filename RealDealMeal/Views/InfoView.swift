//
//  InfoView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 21/08/2025.
//

import SwiftUI

struct InfoView: View {
	// MARK: - Properties

	private let portfolioURL = URL(string: "https://brentvervaet-dev.vercel.app")!
	private let descriptionText = """
RealDealMeal is your go-to app for discovering delicious recipes and meal ideas.
Explore recommendations or get a random recipe to spice up your cooking!
"""

	// MARK: - Body
	var body: some View {
		NavigationStack {
			content
				.navigationTitle("About")
				.navigationBarTitleDisplayMode(.inline)
		}
	}

	// MARK: - Private Views
	private var content: some View {
		VStack(spacing: 20) {
			descriptionTextView
			portfolioLink
			Spacer()
		}
		.padding()
	}

	// Text
	private var descriptionTextView: some View {
		Text(descriptionText)
			.multilineTextAlignment(.center)
	}

	// Link
	private var portfolioLink: some View {
		Link("Visit my Portfolio", destination: portfolioURL)
			.font(.headline)
			.foregroundColor(.blue)
	}
}

#Preview {
	InfoView()
}
