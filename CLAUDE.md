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

## Git Configuration

Repository uses SSH authentication:
```bash
# Push changes
git push origin main

# Pull latest changes
git pull origin main

# Create and push new branch
git checkout -b feature/branch-name
git push -u origin feature/branch-name
```

SSH key location: `~/.ssh/id_ed25519`
Remote URL: `git@github.com:alcides-collective/rekrut-ios-app.git`

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
│   │   ├── InteractiveMaturaView.swift        # NEW: Visual progress bars
│   │   ├── CompactMaturaCalculatorView.swift  # Previous compact design
│   │   └── SimpleMaturaCalculatorView.swift   # Original version
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

### AI Match Questionnaire Redesign (January 2025)
- **Grid-based Layout**: Stable 2-column grid replacing vertical lists
- **Consolidated Steps**: Reduced from 11 to 6 steps (skills on 1 screen)
- **City Selection**: Dynamic sheet for "Blisko domu" option
- **Blue Theme**: Consistent with app's primary color (replaced purple)
- **Performance**: Removed animations to eliminate flickering
- **Navigation**: All controls in one line (back/steps/next)

### Authentication System (January 2025)
- **Apple Sign In Only**: Removed email/password authentication for enhanced security
- Simplified authentication flow with direct Sign in with Apple button
- No separate signup process - Apple handles new user creation
- Automatic user profile creation on first sign in
- Mock user data for development testing with high matura scores

### Dynamic Formula-Based Point Calculation (January 2025)
- **FormulaCalculator Service**: Sophisticated parser for Polish university admission formulas
- Supports various formula patterns:
  - Weighted subjects: `0.5 × matematyka (R) + 0.3 × fizyka (R)`
  - Shorthand notation: `W = 0.5 * MAT_R + 0.3 * INF_R`
  - Max functions: `max(fizyka, chemia, informatyka)`
  - Division: `(mat + fiz + język) / 3`
- Smart subject recognition with Polish aliases
- Handles both basic (P) and extended (R) levels
- StudyProgram extension for easy calculation access

### Progress Indicators Across All Cards (January 2025)
- **Green dots** when user exceeds 100% of threshold
- **Yellow dots** for 80-99% (good chances)
- **Red dots** below 80% (lower chances)
- "+X%" display when above threshold (e.g., "+7%" for 107%)
- Consistent implementation across:
  - TrendingProgramCard
  - RecommendedProgramCard
  - ProgramRowCard
  - AIMatchProgramCard

### Bookmark/Favorite Functionality (January 2025)
- Save programs to user profile
- BookmarkedProgramsView in Profile section
- Bookmark indicators on all program cards
- Swipe to remove from bookmarks
- Empty state with navigation to Explore

### ProgramDetailView UI Improvements (January 2025)
- Reduced spacing between program name and university info (8→4pt)
- Widened essential info panel by reducing padding (24→16pt)
- Made "Twoje szanse" a proper panel with shadow and rounded corners
- Decreased panel spacing for more compact layout (32→24pt)
- Added 60pt top padding to program header
- Extended gradient overlays: dark gradient (3→7 stops), white gradient (6→10 stops, 200→280pt)
- Fixed "Termin składania" alignment to be on same line as date
- Simplified Rekrutacja section with clean VStack layout
- Changed formula background to secondarySystemBackground for better contrast
- Increased progress bar thickness (4→8pt)
- Added smart progress display: nothing at 100%, percentage below 100%, "+X%" above 100%

### AI Match Questionnaire (v0.0.3 - January 2025)
- **Stable Grid Layout**: 2-column grid for answer options, single column for skill ratings
- **Fixed Hero Section**: 200pt height with blue gradient background
- **Left-aligned Questions**: Larger font (.title) positioned at bottom of hero
- **Compact Design**: 
  - Answer panels: 13pt font, left-aligned text, iOS-style shadows
  - Skill ratings: Single row with 5 stars, no transparency changes
  - Reduced from 11 to 8 total steps (consolidated skills)
- **City Picker Sheet**: Appears when "Blisko domu" selected, 25 Polish university cities
- **Visual Consistency**: Blue color scheme throughout (replaced purple)
- **Performance**: Removed animations to prevent flickering
- **Polish UI Elements**: "Możesz wybrać kilka odpowiedzi" shown below multi-select grids

### Interactive Matura Calculator (v0.0.2 - December 2024)
- Complete redesign with visual progress bars
- Text input fields for easy score entry (replaced picker wheels)
- Split color rendering: black text on white, white text on color
- Colorful emoji on white background, monochrome on colored
- All subjects visible without dropdowns or expandable sections
- Performance optimized by removing live program matching
- RoundedRectangle shapes for proper corner rendering at 100%
- Right-aligned numbers with minimal spacing to % symbol
- Placeholder "—" shows when score is empty
- Single "Gotowe" button on keyboard toolbar

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
- Sheet presentations for all detail views (not push navigation)
- "Zamknij" buttons on all sheets for consistency
- Updated UniversityListView and CategoryProgramsView to use sheet presentations

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
6. **Security**: Never commit credentials or tokens to the repository
7. **Performance**: Test on real devices, especially for animations and gestures

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