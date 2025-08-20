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
				FavoritesView()
					.tabItem {
						Label("Favorites", systemImage: "heart.fill")
					}
				
				HomeView()
					.tabItem {
						Label("Home", systemImage: "house")
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
