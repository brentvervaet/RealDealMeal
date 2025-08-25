# RealDealMeal 🍽️

Discover, explore, and save recipes powered by [TheMealDB](https://www.themealdb.com/).

## Overview

RealDealMeal helps you find cooking inspiration fast:

* Get a curated set of random recommended meals on the Home tab.
* Search meals by name with debounced results.
* Browse by meal category.
* View rich recipe details: image, ingredients (auto-composed), and step-by-step instructions.
* Save favorites locally (persisted with `@AppStorage`).
* Share recipes with the iOS share sheet.

## Features

| Area | Highlights |
|------|------------|
| Home | Parallel fetching of unique random meals; pull to refresh button |
| Search | Debounced text search (cancels stale tasks), category filtering |
| Detail | Ingredient normalization (20 API fields → clean array), instruction step parsing |
| Favorites | Persistent JSON storage via `@AppStorage`, instant UI updates |
| Sharing | Native `UIActivityViewController` wrapper |
| Layout | Adaptive grids (2–3 columns) & responsive detail layout (compact vs wide) |

## Architecture

The app follows MVVM with a service layer.

```text
View (SwiftUI)  -> observes  Published state on  ViewModel
ViewModel       -> orchestrates async calls via APIServiceType, transforms raw models
Service         -> fetch + decode (TheMealDB JSON) using async/await
Model           -> Codable structs + computed helpers (ingredients, steps)
```


### Key Design Choices

* Random meal recommendations fetched concurrently with `TaskGroup` and early cancellation when enough unique results are collected.
* Debounced search leverages a cancelable `Task` + `Task.sleep` for a responsive typing experience without flooding the network.
* Ingredient list is synthesized at model level (`Meal.ingredients`) → keeps Views simple and consistent.
* Favorites stored as full `Meal` objects (not just IDs) for offline detail viewing of cached items.

## Data Source

All recipe data comes from the public TheMealDB v1 API (`https://www.themealdb.com/api/json/v1/1/`).

## Requirements

* macOS with Xcode 16 or newer
* iOS 18 simulator or device (older may work)
* Network access

## Getting Started

1. Clone the repository.
2. Open `RealDealMeal.xcodeproj`.
3. Select an iOS Simulator (e.g. iPhone 16 Pro) and press Run.

No API key setup required (TheMealDB free tier endpoints are used).

### Project Structure (excerpt)

```text
RealDealMeal/
 Models/          // Codable models + computed helpers
 Services/        // APIService (network + decoding)
 ViewModels/      // Home, Search/List, Favorites logic
 Views/           // SwiftUI screens & components
```

## Author

Developed by Brent Vervaet. See the in‑app About screen or visit the portfolio link there.

---
Happy cooking! 🍜
