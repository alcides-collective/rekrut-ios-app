# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the Rekrut iOS application codebase.

## 🚀 Quick Start

### Frequently Used Commands

```bash
# Open project in Xcode
open Rekrut/Rekrut.xcodeproj

# Git operations
git status
git add .
git commit -m "feat: Description of changes"
git push origin main
git pull origin main

# Build & Run
rekrutbuild   # Build project and show errors (custom command)
              # Alias for: cd /Users/jakubdudek/Desktop/RekrutApp/Rekrut && xcodebuild -project Rekrut.xcodeproj -scheme Rekrut -sdk iphonesimulator build 2>&1 | grep -E "(error:|warning:|BUILD)" | tail -20

# Build & Run (in Xcode)
cmd+b         # Build
cmd+r         # Run on simulator
cmd+shift+k   # Clean build folder
cmd+u         # Run tests

# Create feature branch
git checkout -b feature/branch-name
git push -u origin feature/branch-name
```

### Repository Configuration
- **Remote**: `git@github.com:alcides-collective/rekrut-ios-app.git`
- **SSH Key**: `~/.ssh/id_ed25519`
- **Default Branch**: `main`

## 📱 Project Overview

**Rekrut** - iOS app for Polish university applicants and students
- **Platform**: iOS 15.0+ (Swift 5, SwiftUI)
- **Architecture**: MVVM
- **Backend**: Firebase (Auth, Firestore, Storage)
- **UI Language**: Polish
- **Code Language**: English (comments/naming)
- **Website**: rekrut.app

### Current Status
- ✅ Core features implemented
- ✅ Tab navigation + profile button
- ✅ Authentication (Apple Sign In)
- ✅ Smart search system
- ✅ Interactive Matura calculator
- ✅ AI Match questionnaire
- ✅ Explore feed with filters
- ✅ Bookmark functionality
- 🚧 Program comparison
- 🚧 Firebase security rules

## 🏗 Architecture & Patterns

### MVVM Structure
```
Models/         # Pure data structures (Codable)
Views/          # SwiftUI views (minimal logic)
ViewModels/     # Business logic (@StateObject/@ObservedObject)
Services/       # External integrations (Firebase, APIs)
Extensions/     # Swift extensions
```

### Naming Conventions
- **Views**: `*View.swift` (e.g., `ExploreView.swift`)
- **ViewModels**: `*ViewModel.swift` (e.g., `CalculatorViewModel.swift`)
- **Models**: Singular nouns (e.g., `University.swift`)
- **Services**: `*Service.swift` (e.g., `FirebaseService.swift`)
- **Extensions**: `Type+Functionality.swift` (e.g., `StudyProgram+PointCalculation.swift`)

### Code Style Preferences
```swift
// iOS 15 compatibility - avoid iOS 16+ APIs
.fontWeight(.bold)          // ✅ Use this
.bold()                     // ❌ iOS 16+ only

// Async/await pattern
Task {
    do {
        let data = try await service.fetchData()
    } catch {
        // Handle error
    }
}

// View state management
@StateObject private var viewModel = SomeViewModel()
@State private var localState = false

// Polish date formatting
let formatter = DateFormatter()
formatter.locale = Locale(identifier: "pl_PL")
formatter.dateStyle = .medium
```

### UI/UX Guidelines
- **Simplicity First**: Minimize clicks and vertical space
- **iOS Native**: Profile in nav bar (not tab bar)
- **Compact Design**: Dropdowns > chips, collapsible sections
- **Smart Defaults**: Pre-fill common values
- **Polish UI**: All user-facing text in Polish
- **Sheet Navigation**: Use sheets for detail views (not push)

## 🎯 Key Features & Implementation

### 1. Navigation Structure
- **5 Tabs**: Explore, Erasmus+, AI Match, Calculator, Search
- **Profile**: Navigation bar button (iOS pattern)
- **Sheets**: All detail views use `.sheet()` presentation

### 2. Authentication (Apple Sign In Only)
```swift
// In AuthViewModel
func signInWithApple() async throws {
    // Apple handles user creation automatically
    // No separate signup flow needed
}
```

### 3. Dynamic Formula Calculator
```swift
// FormulaCalculator supports:
- Weighted: "0.5 × matematyka (R) + 0.3 × fizyka (R)"
- Shorthand: "W = 0.5 * MAT_R + 0.3 * INF_R"
- Max functions: "max(fizyka, chemia, informatyka)"
- Division: "(mat + fiz + język) / 3"
```

### 4. Progress Indicators
- 🟢 Green: >100% threshold (shows "+X%")
- 🟡 Yellow: 80-99% (good chances)
- 🔴 Red: <80% (lower chances)

### 5. AI Match Questionnaire
- 6 steps (consolidated from 11)
- 2-column grid layout
- Blue theme throughout
- City picker sheet for "Blisko domu"
- No animations (performance)

### 6. Search System
- Smart search across all fields
- No filter UI needed
- Mixed results (programs + universities)
- Recent searches in UserDefaults

## 🎓 Rekrut Score™ System

Our proprietary 0-100 scoring system standardizes admission chances across Polish universities.

### Components
1. **Base Score (40%)**: Normalized threshold
2. **Competition (30%)**: Slots-to-applicants ratio
3. **Historical Trend (20%)**: 3-year movement
4. **Field Adjustment (10%)**: Difficulty modifier

### Visual Scale
- **0-70**: 🟢 Good chances
- **71-85**: 🟡 Moderate competition
- **86-100**: 🔴 Highly competitive

## 📁 File Structure

```
Rekrut/
├── App/
│   └── RekrutApp.swift                    # Entry point
├── Models/
│   ├── User.swift                         # Auth model
│   ├── University.swift                   # University data
│   ├── StudyProgram.swift                 # Program details
│   ├── MaturaScore.swift                  # Exam scores
│   └── ErasmusProgram.swift               # Exchange programs
├── Views/
│   ├── MainTabView.swift                  # Tab navigation
│   ├── Auth/LoginView.swift               # Apple Sign In
│   ├── Calculator/InteractiveMaturaView.swift
│   ├── Comparison/ComparisonView.swift
│   ├── Explore/ExploreFeedView.swift
│   ├── Profile/ProfileView.swift
│   ├── Search/SearchView.swift
│   └── AIMatch/AIMatchView.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   └── CalculatorViewModel.swift
├── Services/
│   ├── FirebaseService.swift              # Singleton
│   ├── FormulaCalculator.swift            # Point calculation
│   └── MockDataService.swift              # Test data
└── Resources/
    └── GoogleService-Info.plist           # Firebase config
```

## 🔥 Firebase Structure

```
Firestore:
├── users/{userId}/
│   ├── profile
│   ├── bookmarks
│   └── preferences
├── universities/{universityId}/
├── programs/{programId}/
│   ├── rekrutScore: number
│   ├── lastYearThreshold: number
│   └── formula: string
└── erasmus/{programId}/

Realtime Database:
├── searchHistory/
└── calculations/
```

## 🛠 Common Tasks

### Adding a New View
1. Create view in appropriate folder
2. Add ViewModel if complex logic needed
3. Update navigation/sheets
4. Add mock data if needed
5. Test on iOS 15.0 simulator

### Firebase Operations
```swift
// Always use singleton
let service = FirebaseService.shared

// Fetch data
Task {
    do {
        let programs = try await service.fetchPrograms()
    } catch {
        print("Error: \(error)")
    }
}
```

### Testing Checklist
- [ ] iOS 15.0 compatibility
- [ ] Polish UI text correct
- [ ] Animations smooth
- [ ] Offline handling
- [ ] Empty states
- [ ] Error states

## ⚠️ Important Notes

1. **Polish UI**: All user-facing text must be in Polish
2. **iOS 15 Target**: Test features on iOS 15.0 simulator
3. **Compact Design**: Mobile screens are small - optimize space
4. **Performance**: Remove unnecessary animations
5. **Security**: Never commit credentials or API keys
6. **Git Workflow**: Feature branches → PR → main

## 📝 Recent Changes Log

### January 2025
- Redesigned AI Match with stable grid layout
- Implemented Apple Sign In only authentication
- Added dynamic formula-based calculations
- Enhanced all program cards with progress indicators
- Added bookmark/favorite functionality
- Improved ProgramDetailView spacing and gradients
- Smart search with mixed results

### December 2024
- Interactive Matura Calculator with progress bars
- Explore feed with dropdown filters
- Sheet-based navigation pattern

## 🚨 Troubleshooting

### Common Issues
1. **Build fails**: Clean build folder (cmd+shift+k)
2. **Firebase errors**: Check GoogleService-Info.plist
3. **UI glitches**: Test on real device
4. **Polish characters**: Ensure UTF-8 encoding

### Debug Commands
```bash
# Check git status
git status

# View recent commits
git log --oneline -10

# Reset local changes
git checkout -- .

# Update dependencies
cd Rekrut && swift package update
```