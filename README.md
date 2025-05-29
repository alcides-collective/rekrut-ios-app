# Rekrut

iOS application for university applicants and students in Poland. Designed specifically for Polish high school students preparing for university admission, featuring an innovative scoring system and AI-powered recommendations.

## Implementation Status

### ✅ Completed Features
- **Xcode project** initialized with SwiftUI (iOS 15.0+)
- **Firebase SDK** integrated (Auth, Core, Database, Firestore, Storage)
- **MVVM architecture** with clean separation of concerns
- **Tab-based navigation** with 5 main sections
- **Polish language UI** throughout the application
- **Full authentication system** with user profiles and secure login
- **Animated launch screen** with smooth transitions
- **Dark mode support** for better viewing experience

#### 🎯 Eksploruj (Explore)
- Compact dropdown filters for study mode, city, and degree level
- Trending programs with visual cards and Rekrut Score™ indicators
- Personalized AI recommendations based on user profile
- Category browsing for different fields of study
- Top universities section with quick access
- Smart loading states and smooth animations

#### 🔍 Szukaj (Search)
- Intelligent search across programs, universities, and cities
- Recent searches with persistent storage
- Popular search suggestions
- Mixed results display (programs + universities)
- Real-time search with relevance-based sorting
- No complex filters - simple and intuitive UX

#### 🎯 AI Match
- 5-step personality and preference questionnaire
- AI-powered program matching with percentage scores
- Personalized recommendations based on interests and skills
- Visual progress indicators and smooth transitions
- Results saved to user profile for future reference

#### 📊 Kalkulator (Calculator)
- **Interactive visual design** with color-coded progress bars (December 2024)
- Text input fields for precise score entry
- All subjects visible without dropdowns or collapsible sections
- Visual feedback: red (fail), yellow (medium), green (good)
- Split text rendering: black on white, white on color
- Colorful emoji on white background, monochrome on colored
- Support for all mandatory and optional Matura subjects
- Inspirational quotes for each subject
- Real-time point calculation
- Performance optimized without live program matching

#### 📋 Porównanie (Comparison)
- Side-by-side comparison of up to 3 study programs
- Key metrics comparison including Rekrut Score™
- Visual indicators for better/worse values
- Detailed requirements and admission info

#### 👤 Profil (Profile)
- Accessible via top-right navigation button (iOS pattern)
- User account management and preferences
- Saved programs and calculation history
- Logout functionality with proper state cleanup

### 🚧 In Progress
- Erasmus+ program integration
- University detail pages with comprehensive information
- Firebase security rules optimization
- Production deployment preparation

### 📋 Planned Features
- Saved programs and favorites synchronization
- Push notifications for application deadlines
- Offline mode with cached data
- Analytics integration for better recommendations
- Social features for connecting with other applicants
- PDF export of calculation results

## Key Features

### 🎓 Rekrut Score™ System
Our proprietary scoring system (0-100) that standardizes admission chances across all Polish universities:
- **0-70** (Green): Good admission chances
- **70-85** (Yellow): Moderate competition
- **85-100** (Red): Highly competitive

The score considers multiple factors including historical thresholds, competition levels, and field-specific adjustments.

### 📱 Core Functionality

- **Eksploruj (Explore)**: Discover trending programs with AI-powered recommendations tailored to your profile
- **Szukaj (Search)**: Find programs and universities instantly with our intelligent search system
- **AI Match**: Take a 5-step questionnaire to get personalized program recommendations with match percentages
- **Kalkulator**: Calculate your Matura points with our space-efficient calculator supporting the new exam system
- **Porównanie**: Compare up to 3 programs side-by-side with visual indicators for better decision making
- **Profil**: Manage your account, view saved programs, and track your application journey

### 🌟 Recent Updates (January 2025 - v0.0.3)
- **Redesigned**: AI Match with stable grid layout and consolidated steps
- **New**: City picker sheet for "Close to home" location selection
- **Updated**: Blue color scheme throughout AI Match (replaced purple)
- **Improved**: Left-aligned questions in hero sections with larger font
- **Fixed**: Removed animations to eliminate panel flickering
- **Added**: Polish hint text for multi-select questions

### Previous Updates (December 2024)
- **New**: Interactive Matura calculator with visual progress bars
- **New**: Sheet-based navigation for all detail views
- **Updated**: Text input fields replace picker wheels in calculator
- **Updated**: Performance optimizations throughout the app
- **Removed**: Live program matching from calculator (performance)
- **New**: Smart search with recent searches and suggestions
- **New**: Erasmus+ program integration (coming soon)

## Setup and Run

### Prerequisites
- Xcode 15 or later
- iOS 15.0+ device or simulator
- Firebase project with `GoogleService-Info.plist`

### Installation Steps

1. Clone the repository
```bash
git clone https://github.com/yourusername/rekrut.git
cd rekrut
```

2. Open the project in Xcode
```bash
open Rekrut/Rekrut.xcodeproj
```

3. Add Firebase configuration
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add it to the Xcode project (drag to project navigator)
   - Ensure it's added to the Rekrut target

4. Build and run
   - Select your target device/simulator
   - Press ⌘+R or click the Run button

## Project Structure

```
Rekrut/
├── App/                 # App configuration and entry point
├── Views/              # SwiftUI views
│   ├── Explore/        # Feed and discovery
│   ├── Calculator/     # Matura calculator
│   ├── Comparison/     # Program comparison
│   └── Profile/        # User profile
├── ViewModels/         # Business logic
├── Models/             # Data models
├── Services/           # Firebase and API services
├── Utils/              # Utilities and extensions
└── Resources/          # Assets and localization
```

## Technologies & Architecture

- **Language**: Swift 5.0+
- **UI Framework**: SwiftUI (iOS 15.0+)
- **Backend**: Firebase Suite
  - Authentication for secure user management
  - Firestore for university and program data
  - Realtime Database for user preferences and search history
  - Storage for images and documents
- **Architecture**: MVVM with clear separation of concerns
- **State Management**: Combine + @Published properties
- **Dependency Management**: Swift Package Manager (SPM)
- **Design System**: SF Symbols + custom color palette
- **Minimum iOS**: 15.0 (87% device coverage)

## Data Sources

- **University Data**: Aggregated from official Polish university websites
- **Admission Thresholds**: Historical data from the last 3 years
- **Matura Formulas**: Official recruitment formulas from each university
- **Erasmus+ Programs**: EU official database (integration pending)

## Performance & Optimization

- Lazy loading for all list views
- Image caching for university and program images
- Offline support for previously viewed content
- Optimized Firebase queries with proper indexing
- Smooth animations with explicit timing curves

## Contributing

This project is currently in active development. For more information, visit [rekrut.app](https://rekrut.app).

## License

Proprietary - All rights reserved. This is a commercial project.