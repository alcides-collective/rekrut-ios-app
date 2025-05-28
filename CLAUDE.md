# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Rekrut** - iOS application for university applicants and students in Poland
- App Name: Rekrut
- Website: rekrut.app
- Platform: iOS 15.0+ (Swift 5 + SwiftUI)
- Backend: Firebase (Auth, Firestore, Realtime Database, Storage)
- Architecture: MVVM
- Language: Polish (UI), English (code/comments)

## Project Status

Active development phase with core features implemented:
- ✅ Tab-based navigation (5 tabs + profile button)
- ✅ User authentication flow
- ✅ Smart search system
- ✅ Compact Matura calculator
- ✅ AI Match questionnaire
- ✅ Explore feed with filters
- 🚧 Program comparison
- 🚧 Firebase security rules

## Build & Development Commands

```bash
# Open project in Xcode
open Rekrut/Rekrut.xcodeproj

# Clean build folder
cmd+shift+k (in Xcode)

# Build project
cmd+b (in Xcode)

# Run on simulator
cmd+r (in Xcode)
```

## Architecture & Conventions

### MVVM Pattern
- **Models**: Pure data structures (Codable)
- **Views**: SwiftUI views with minimal logic
- **ViewModels**: Business logic, marked with @StateObject/@ObservedObject
- **Services**: External integrations (Firebase, APIs)

### Naming Conventions
- Views: `*View.swift` (e.g., `ExploreView.swift`)
- ViewModels: `*ViewModel.swift` (e.g., `CalculatorViewModel.swift`)
- Models: Singular nouns (e.g., `University.swift`)
- Services: `*Service.swift` (e.g., `FirebaseService.swift`)

### UI/UX Guidelines
- **Simplicity First**: Reduce clicks, minimize vertical space
- **iOS Native Patterns**: Profile in nav bar, not tab bar
- **Polish UI**: All user-facing text in Polish
- **Compact Design**: Dropdown menus over chips, collapsible sections
- **Smart Defaults**: Pre-fill common values, hide optional fields

### Code Style
- iOS 15.0 compatibility (avoid iOS 16+ APIs)
- Use `.fontWeight()` instead of `.bold()` for iOS 15
- Prefer SwiftUI over UIKit
- Keep views under 200 lines
- Extract reusable components

## Current File Structure

```
Rekrut/
├── App/
│   ├── RekrutApp.swift              # App entry point
│   └── AppDelegate.swift            # Firebase initialization
├── Models/
│   ├── User.swift                   # User authentication model
│   ├── University.swift             # University data model
│   ├── StudyProgram.swift           # Study program details
│   ├── MaturaScore.swift            # Matura exam scores
│   └── StudyMode.swift              # Study mode enum
├── Views/
│   ├── MainTabView.swift            # Tab navigation (5 tabs)
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   └── SignUpView.swift
│   ├── Calculator/
│   │   ├── CompactMaturaCalculatorView.swift  # NEW: Ultra-compact design
│   │   └── SimpleMaturaCalculatorView.swift   # Previous version
│   ├── Comparison/
│   │   └── ComparisonView.swift
│   ├── Explore/
│   │   └── ExploreFeedView.swift    # NEW: Dropdown filters
│   ├── Profile/
│   │   └── ProfileView.swift
│   ├── Search/
│   │   ├── SearchView.swift         # NEW: Smart search
│   │   └── SearchSuggestionsView.swift
│   ├── AIMatch/
│   │   └── AIMatchView.swift        # 5-step questionnaire
│   └── Shared/
│       └── LoadingView.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── CalculatorViewModel.swift
│   └── ComparisonViewModel.swift
├── Services/
│   ├── FirebaseService.swift        # Firebase integration
│   └── MockDataService.swift        # Test data
└── Resources/
    └── GoogleService-Info.plist     # Firebase config
```

## Recent Changes & Patterns

### Compact Matura Calculator (NEW)
- Collapsible extended level section marked "(opcjonalnie)"
- Horizontal scroll for score inputs
- Smart subject selection chips for additional subjects
- Warning indicators for failing scores (<30%)
- 60% less vertical space usage

### Smart Search System (NEW)
- No filtering UI - intelligent search across all fields
- Recent searches persisted in UserDefaults
- Mixed results (programs + universities)
- Relevance-based sorting
- Search suggestions when query is empty

### Explore Feed Improvements
- Replaced chip filters with dropdown menus
- Reduced vertical space usage by 40%
- Smoother animations with explicit durations
- Removed decorative hero section

### Navigation Structure
- 5 tabs: Explore, Search, Calculator, Compare, AI Match
- Profile accessible via navigation bar button (iOS pattern)
- NavigationViewWithProfile wrapper for consistent header

## Common Tasks

### Adding a New View
1. Create view file in appropriate folder
2. Add to navigation if needed
3. Create ViewModel if complex logic required
4. Update MockDataService if test data needed

### Firebase Integration
```swift
// Use singleton
FirebaseService.shared

// Async/await pattern
Task {
    do {
        let data = try await firebaseService.fetchData()
    } catch {
        // Handle error
    }
}
```

### iOS 15 Compatibility Fixes
```swift
// ❌ iOS 16+ only
.fontWeight(.bold)
.bold()

// ✅ iOS 15 compatible
.fontWeight(.bold)
Text("").bold()  // without parameter

// For conditional bold
if condition {
    Text("").bold()
} else {
    Text("")
}
```

## Testing Approach

- SwiftUI Previews for UI testing
- MockDataService for test data
- Manual testing on iOS 15.0 simulator

## Important Notes

1. **Always maintain Polish language in UI** - all user-facing text
2. **Keep designs compact** - mobile screens are small
3. **Follow iOS native patterns** - users expect familiarity
4. **Prioritize UX over features** - simplicity wins
5. **Test on iOS 15.0** - our minimum deployment target

## 🎓 Proprietary Rekrut Score™ System

### Overview
Rekrut Score is our innovative 0-100 standardized scoring system that solves the problem of comparing admission chances across different Polish universities with varying admission formulas.

### Why Rekrut Score?
- Each university uses different Matura subject weights
- Thresholds vary wildly (some use 0-100, others 0-600+ scales)
- Students can't easily compare their chances across programs
- Our score provides instant, visual admission probability

### Rekrut Score Calculation
```swift
struct RekrutScoreCalculator {
    func calculate(program: StudyProgram) -> Int {
        let baseScore = normalizeThreshold(program.lastYearThreshold)
        let competition = calculateCompetitionFactor(program)
        let fieldBonus = getFieldAdjustment(program.field)
        let historicalTrend = analyzeHistoricalData(program.scoreHistory)
        
        let rawScore = baseScore * competition * fieldBonus * historicalTrend
        return min(max(Int(rawScore), 0), 100)
    }
}
```

### Score Components
1. **Base Score** (40%): Normalized threshold from university's scale
2. **Competition Factor** (30%): Slots-to-applicants ratio
3. **Historical Trend** (20%): 3-year threshold movement
4. **Field Adjustment** (10%): Difficulty modifier by field

### Visual Indicators
- **0-70** 🟢: Good chances ("Dobre szanse")
- **71-85** 🟡: Moderate ("Średnia konkurencja")
- **86-100** 🔴: Highly competitive ("Wysoka konkurencja")

### Implementation Details
- Stored as `rekrutScore` in StudyProgram model
- Updated annually after admission results
- Displayed prominently in UI with color coding
- Actual thresholds shown in detail views for transparency
- Used for sorting and filtering in explore/search

## Firebase Structure

```
Firestore:
├── users/
│   └── {userId}/
├── universities/
│   └── {universityId}/
├── programs/
│   └── {programId}/
│       ├── rekrutScore: number (0-100)
│       ├── lastYearThreshold: number (actual points)
│       └── scoreHistory: array<{year, score}>
└── erasmus/
    └── {programId}/

Realtime Database:
├── userPreferences/
├── searchHistory/
└── calculations/
```

## Common Patterns

### View State Management
```swift
struct SomeView: View {
    @StateObject private var viewModel = SomeViewModel()
    @State private var localState = false
    
    var body: some View {
        // View content
    }
}
```

### Async Data Loading
```swift
.onAppear {
    Task {
        await viewModel.loadData()
    }
}
```

### Polish Date Formatting
```swift
let formatter = DateFormatter()
formatter.locale = Locale(identifier: "pl_PL")
formatter.dateStyle = .medium
```