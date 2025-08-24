# MVVM Flow — RealDealMeal

This document explains how the MVVM layers interact in RealDealMeal. It maps files in the project to the MVVM roles and describes the runtime flow, data shapes, and common interactions.

## Files and roles

- Models
  - `Models/Meal.swift` — Meal model and `MealResponse`. Contains computed helpers `ingredients` and `instructionSteps` used by Views.
  - `Models/MealCategory.swift` — Category model and `CategoryResponse`.

- Services (Data layer)
  - `Services/APIService.swift` — Single source for network I/O. Conforms to `APIServiceType` so ViewModels can be tested/mocked.

- ViewModels (State + business logic)
  - `ViewModels/HomeViewModel.swift` — Loads multiple random meals for the Home screen.
  - `ViewModels/MealListViewModel.swift` — Handles search, category loading, and loading meals by category. Debounces user input and maps API errors to user-friendly messages.
  - `ViewModels/FavoritesViewModel.swift` — Manages persistent favorites via `@AppStorage` and exposes `@Published var favorites`.

- Views (Presentation)
  - `Views/HomeView.swift` — Observes `HomeViewModel` and renders recommended meals grid.
  - `Views/MealListView.swift` — Observes `MealListViewModel` for search, categories, and result list.
  - `Views/MealDetailView.swift` — Shows details for a `Meal`. Uses `FavoritesViewModel` from `EnvironmentObject` for favorite toggling.
  - `Views/FavoritesView.swift` — Observes `FavoritesViewModel` from environment to list saved meals.

## Typical runtime flows

### App start — Home

- HomeView is created with a `@StateObject private var homeVM = HomeViewModel()`.
- `onAppear` calls `homeVM.loadRecommendedMeals()` (async).
- `HomeViewModel` uses `APIService` to fetch multiple random meals in parallel.
- `HomeView` observes `homeVM.recommendedMeals` and the grid updates when data arrives.

### Searching for meals (MealListView)

- `MealListView` creates `@StateObject private var mealListVM = MealListViewModel()`.
- User types into the `TextField` which binds to `mealListVM.searchQuery`.
- `onChange` triggers `mealListVM.searchMeals()` which debounces input using a `Task`.
- After the debounce, `MealListViewModel.performSearch()` calls `service.fetchMeals(query:)`.
- The `meals` published property updates and `MealListView` renders the list.
- Errors from the API are converted to a human-facing `errorMessage` string by the ViewModel.

### Viewing details

- Tapping a meal triggers navigation to `MealDetailWrapperView(mealID:)`.
- The wrapper calls `service.fetchMealDetail(id:)` (async) and when ready, presents `MealDetailView(meal:)`.
- `MealDetailView` reads `meal.ingredients` and `meal.instructionSteps` and renders them.
- Favorite toggling in `MealDetailView` calls `favoritesVM.toggleFavorite(meal)` which updates `@AppStorage` and `@Published favorites`.

### Favorites

- `FavoritesView` receives `FavoritesViewModel` through `@EnvironmentObject` (injected at the App root).
- When `favoritesVM.favorites` changes, the view re-renders automatically.

## Data shapes

- API responses decode to `MealResponse` or `CategoryResponse`.
- A single `Meal` contains many flat string fields (ingredient1..20, measure1..20). ViewModel/View use `meal.ingredients: [(ingredient, measure)]` for ease of display.

## Error handling and edge cases

- ViewModels map `APIError` to strings for display.
- `MealListViewModel` handles cancellation when user types quickly by canceling previous search Task.
- `HomeViewModel` collects unique random meals and cancels remaining tasks early when enough unique meals arrive.
- `FavoritesViewModel` persists decoded favorites in `@AppStorage` as JSON. Corrupt/empty data results in an empty favorites list.

## Testing recommendations

- Provide a mock `APIServiceType` implementation and inject into ViewModels' init for unit tests.
- Test `MealListViewModel` debouncing behavior using an async test and verifying cancellation paths.
- Test `FavoritesViewModel` persistence by swapping out the backing store in tests (or injecting a protocol around persistence).

## Quick MVVM contract summary

- Inputs: user actions in Views (search text, taps, category selection).
- Outputs: Published properties on ViewModels (`meals`, `isLoading`, `errorMessage`, `favorites`).
- Errors: Propagated from `APIService` as `APIError`; ViewModels convert to user-facing strings.

## Where to extend

- Add caching in `APIService` for repeated lookups.
- Add pagination for category lists if API supports it.
- Add dependency injection for AppStorage to make `FavoritesViewModel` fully testable.
