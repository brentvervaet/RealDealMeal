//
//  HomeView.swift
//  RealDealMeal
//
//  Created by Brent Vervaet on 20/08/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
		NavigationStack{
			VStack{
				Text("Hello, World!")
			}
			.navigationTitle("Home")
		}
    }
}

#Preview {
    HomeView()
}
