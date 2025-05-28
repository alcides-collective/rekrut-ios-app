# Rekrut - Polish University Admission Assistant

## Project Overview
Rekrut is a comprehensive iOS application designed specifically for Polish high school students (maturzyści) preparing for university admission. The app features a proprietary Rekrut Score™ system that standardizes admission chances across all Polish universities, making it easy to compare programs despite varying admission formulas.

## Target Audience
- Primary: Polish high school students taking Matura exams
- Secondary: Gap year students reapplying to universities
- Future: Current university students (for Erasmus+ programs)

## Core Features (Implemented)

### 1. Rekrut Score™ System
- Proprietary 0-100 scoring that standardizes admission chances
- Visual indicators: Green (0-70), Yellow (71-85), Red (86-100)
- Considers historical data, competition levels, and field difficulty
- Makes comparing different universities intuitive

### 2. Eksploruj (Explore) Feed
- Trending study programs with Rekrut Score indicators
- AI-powered personalized recommendations
- Compact dropdown filters (study mode, city, degree level)
- Category browsing and top universities section

### 3. Inteligentne Wyszukiwanie (Smart Search)
- Search across programs, universities, cities, and fields
- Recent searches and popular suggestions
- Mixed results with relevance-based sorting
- No complex filters - simple and intuitive

### 4. AI Match Questionnaire
- 5-step personality and preference assessment
- Generates personalized program recommendations
- Shows match percentage for each suggestion
- Results saved to user profile

### 5. Kalkulator Matury (Matura Calculator)
- Ultra-compact design (60% less vertical space)
- Supports new Polish Matura exam system
- Optional extended level fields in collapsible section
- Real-time validation with pass/fail indicators
- Smart subject selection for additional subjects

### 6. Porównanie Kierunków (Program Comparison)
- Compare up to 3 study programs side-by-side
- Visual indicators for better/worse metrics
- Includes Rekrut Score, requirements, and duration
- Helps make informed decisions

### 7. Erasmus+ Integration (Planned)
- Browse exchange opportunities by country and field
- Filter by duration and requirements
- Application deadline notifications

## Technical Requirements

### Technology Stack
- **Language**: Swift 5.0+
- **UI Framework**: SwiftUI (iOS 15.0+ for compatibility)
- **Backend**: Firebase Suite
  - Authentication for user management
  - Firestore for university/program data
  - Realtime Database for preferences
  - Storage for images
- **Architecture**: MVVM with Combine
- **State Management**: @Published properties + ObservableObject
- **Dependency Management**: Swift Package Manager (SPM)

### Data Structure Changes
Recent modifications to improve performance and UX:
- **Removed**: Employment rate data (focus on academics)
- **Removed**: Required subjects lists (simplified to boolean flags)
- **Changed**: Duration from years to semesters
- **Added**: Rekrut Score™ for all programs
- **Added**: Score history for trend analysis
- **Optimized**: Separate collections for better query performance

### UI/UX Principles
- **Polish Language Only**: All UI text in Polish
- **Compact Design**: Minimize vertical space usage
- **iOS Native Patterns**: Profile in nav bar, not tab bar
- **Visual Hierarchy**: Rekrut Score always prominent
- **Smooth Animations**: 0.3s standard duration
- **SF Symbols**: Consistent iconography
- **Dark Mode**: Full support implemented
- **Accessibility**: VoiceOver and Dynamic Type ready

### Key Design Patterns
- Use `@Published` properties and `ObservableObject` for reactive UI updates
- Implement proper error handling with user-friendly messages
- Create reusable components for common UI elements
- Use Swift's async/await for asynchronous operations

## Development Approach

### Current Implementation Status
```
✅ COMPLETED:
- Full MVVM architecture
- 5-tab navigation + profile
- Complete authentication flow
- Smart search with suggestions
- Ultra-compact Matura calculator
- AI Match questionnaire
- Program comparison view
- Explore feed with filters
- Dark mode support
- Polish UI throughout

🚧 IN PROGRESS:
- Erasmus+ integration
- University detail pages
- Push notifications
- Offline mode

📋 BACKLOG:
- Social features
- PDF export
- Analytics dashboard
```

### Testing Strategy
- Focus on unit tests for critical business logic (Matura calculations, AI matching algorithms)
- Use XCTest framework for testing
- Implement UI tests for key user flows

### Security Considerations
- Implement proper Firebase security rules
- Store sensitive user data securely
- Use App Transport Security (ATS) for all network communications
- Implement proper user authentication (consider Firebase Auth)

## Deployment
- Target iOS 15.0 or later for modern SwiftUI features
- Prepare for App Store submission following Apple's guidelines
- Implement proper app metadata and screenshots
- Consider implementing analytics for user behavior tracking

## Key Development Guidelines

### Polish Language Requirements
- ALL user-facing text must be in Polish
- No English in the UI (code comments in English are OK)
- Use proper Polish grammar and terminology

### Performance Requirements
- App launch: < 2 seconds
- Search results: < 500ms
- Smooth 60 FPS animations
- Lazy loading for all lists
- Image caching implemented

### iOS 15.0 Compatibility
- Avoid iOS 16+ APIs
- Use .fontWeight() instead of .bold() modifier
- Test on iOS 15.0 simulator regularly

### Current Focus
- Polish university applicants only
- Matura exam system
- Undergraduate programs (licencjat, inżynierskie)
- Major Polish cities