# RealDealMeal 🍽️

Discover, explore, and save recipes powered by [TheMealDB](https://www.themealdb.com/) — built with SwiftUI, async/await, and a clean MVVM architecture.

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
| Error Handling | Granular `APIError` mapping to user-friendly messages |

## Architecture

The app follows MVVM with a thin service layer.

```text
View (SwiftUI)  -> observes  Published state on  ViewModel
ViewModel       -> orchestrates async calls via APIServiceType, transforms raw models
Service         -> fetch + decode (TheMealDB JSON) using async/await
Model           -> Codable structs + computed helpers (ingredients, steps)
```

Detailed flow diagrams and responsibilities: see `docs/MVVM_FLOW.md`.

### Key Design Choices

* `APIServiceType` protocol allows mocking in future unit tests.
* Random meal recommendations fetched concurrently with `TaskGroup` and early cancellation when enough unique results are collected.
* Debounced search leverages a cancelable `Task` + `Task.sleep` for a responsive typing experience without flooding the network.
* Ingredient list is synthesized at model level (`Meal.ingredients`) → keeps Views simple and consistent.
* Favorites stored as full `Meal` objects (not just IDs) for offline detail viewing of cached items.

## Data Source

All recipe data comes from the public TheMealDB v1 API (`https://www.themealdb.com/api/json/v1/1/`). Only read operations are performed; no user-generated content is sent.

## Requirements

* macOS with Xcode 15 or newer (Swift 5.9+)
* iOS 17 simulator or device (older may work but not explicitly targeted yet)
* Network access

## Getting Started

1. Clone the repository.
2. Open `RealDealMeal.xcodeproj` (or the workspace if you later add SwiftPM packages).
3. Select an iOS Simulator (e.g. iPhone 16) and press Run.

No API key setup required (TheMealDB free tier endpoints are used).

### Project Structure (excerpt)

```text
RealDealMeal/
 Models/          // Codable models + computed helpers
 Services/        // APIService (network + decoding)
 ViewModels/      // Home, Search/List, Favorites logic
 Views/           // SwiftUI screens & components
```

## Notable Implementation Details

* Concurrency: Async/await networking; parallel random fetch with `withThrowingTaskGroup`.
* Cancellation: Search tasks cancelled on new input; random meal tasks cancelled early when quota reached.
* State Management: Pure SwiftUI + `@StateObject` + `@EnvironmentObject` for Favorites.
* Persistence: Lightweight JSON encoding/decoding of favorites via `@AppStorage`.
* UI Adaptivity: Grid column count adapts to width; detail view reflows for wider layouts.

## Error Handling Strategy

`APIService` maps low-level issues into an `APIError` enum (bad URL, transport, server(status), decoding). ViewModels interpret these to user-friendly strings so Views remain declarative and minimal.

## Author

Developed by Brent Vervaet. See the in‑app About screen or visit the portfolio link there.

---
Happy cooking! 🍜
