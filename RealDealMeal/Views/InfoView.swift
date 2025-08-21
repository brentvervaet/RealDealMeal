//
//  InfoView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 21/08/2025.
//

import SwiftUI

struct InfoView: View {
	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				Text("RealDealMeal is your go-to app for discovering delicious recipes and meal ideas. Explore recommendations or get a random recipe to spice up your cooking!")
					.padding()
				Link("Visit my Portfolio", destination: URL(string: "https://brentvervaet-dev.vercel.app")!)
					.font(.headline)
					.foregroundColor(.blue)
				Spacer()
			}
			.navigationTitle("About")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

#Preview {
    InfoView()
}
