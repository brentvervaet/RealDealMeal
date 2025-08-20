//
//  RealDealMealApp.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 09/08/2025.
//

import SwiftUI

@main
struct RecipeFinderApp: App {
	@StateObject private var favoritesVM = FavoritesViewModel()
	
	var body: some Scene {
		WindowGroup {
			TabView {
				
				HomeView()
					.tabItem {
						Label("Home", systemImage: "house")
					}
				FavoritesView()
					.tabItem {
						Label("Favorites", systemImage: "star.fill")
					}
				MealListView()
					.tabItem {
						Label("Search", systemImage: "magnifyingglass")
					}
				
			}
			.environmentObject(favoritesVM)
		}
	}
}
