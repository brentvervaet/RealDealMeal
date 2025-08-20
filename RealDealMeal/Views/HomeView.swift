//
//  HomeView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import SwiftUI

struct HomeView: View {
	@StateObject private var homeVM = HomeViewModel()
	@EnvironmentObject var favoritesVM: FavoritesViewModel
	
	var body: some View {
		NavigationStack {
			VStack{
				Text("home")
			}
			//TODO: daily recipes
			.navigationTitle("Home")
		}
	}
}

/* TODO: meal card
 struct DailyMealCard: View {
	let meal: Meal
	
	var body: some View {
		VStack {
			AsyncImage(url: URL(string: meal.strMealThumb)) { image in
				image.resizable()
					.scaledToFill()
			} placeholder: {
				Color.gray.opacity(0.3)
			}
			.frame(width: 160, height: 100)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			
			Text(meal.strMeal)
				.font(.headline)
				.lineLimit(2)
				.frame(width: 160, alignment: .leading)
		}
	}
}*/

#Preview {
	HomeView()
}
