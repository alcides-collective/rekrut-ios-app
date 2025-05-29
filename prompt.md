# Rekrut - Project Brief

## 🎯 Mission Statement

Create an intuitive iOS application that empowers Polish high school students to make informed university choices by providing personalized recommendations, transparent admission calculations, and comprehensive program information.

## 👥 Target Audience

### Primary Users
- **High school students** (ages 17-19) preparing for university admission
- **Matura exam candidates** needing to calculate their admission points
- **Parents** helping their children navigate university options

### User Needs
- Clear understanding of admission requirements
- Realistic assessment of acceptance chances
- Discovery of programs matching their interests
- Simplified comparison of universities
- Deadline tracking and reminders

## 🏗 Core Architecture

### Technical Foundation
- **Platform**: iOS 15.0+ (iPhone only initially)
- **Language**: Swift 5 with SwiftUI
- **Backend**: Firebase ecosystem
- **Architecture**: MVVM pattern
- **Authentication**: Sign in with Apple

### Design Philosophy
- **Polish-first**: All UI text in Polish
- **Simplicity**: Reduce cognitive load
- **Visual clarity**: Progress bars and indicators
- **Native iOS**: Follow Apple HIG
- **Offline-capable**: Core features work offline

## 🌟 Feature Specifications

### 1. Smart Matura Calculator
**Purpose**: Calculate admission points using each university's unique formula

**Requirements**:
- Visual progress bars for each subject
- Support for basic (P) and extended (R) levels
- Real-time calculation as user types
- Color-coded chance indicators
- Formula transparency

### 2. AI Match Questionnaire
**Purpose**: Recommend programs based on interests and preferences

**Requirements**:
- 6-step questionnaire flow
- Grid-based answer selection
- Location preferences with city picker
- Skill and interest assessment
- Personalized results with reasoning

### 3. University Explorer
**Purpose**: Browse and discover university programs

**Requirements**:
- Trending and recommended sections
- Filter by mode, city, degree level
- University ranking display
- Program cards with key info
- Quick bookmark functionality

### 4. Intelligent Search
**Purpose**: Find programs and universities instantly

**Requirements**:
- Search across all data fields
- Recent searches persistence
- Mixed results (programs + universities)
- Relevance-based sorting
- No complex filter UI

### 5. Program Comparison
**Purpose**: Compare programs side-by-side

**Requirements**:
- Add up to 3 programs
- Compare requirements, thresholds, deadlines
- Visual difference highlighting
- Export comparison results
- Save comparison sets

### 6. User Profile
**Purpose**: Personalized experience and saved data

**Requirements**:
- Apple Sign In integration
- Bookmarked programs
- Matura scores storage
- Preference settings
- Application tracking

## 📊 Data Management

### University Data
- Complete Polish university database
- Current year admission thresholds
- Historical admission data (3 years)
- Program descriptions and requirements
- Contact information and deadlines

### User Data
- Secure authentication tokens
- Encrypted personal information
- Local storage for offline access
- Cloud sync for multi-device
- GDPR compliance

## 🎨 UI/UX Guidelines

### Visual Design
- **Color Scheme**: Blue primary, system colors
- **Typography**: SF Pro Display/Text
- **Spacing**: 8pt grid system
- **Icons**: SF Symbols
- **Animations**: Subtle, < 0.3s

### Interaction Patterns
- Sheet presentations for details
- Swipe actions for quick tasks
- Pull-to-refresh for updates
- Haptic feedback for actions
- Loading states for all async operations

### Accessibility
- VoiceOver support throughout
- Dynamic Type compliance
- High contrast mode
- Reduced motion support
- Clear touch targets (44pt minimum)

## 🚀 Development Priorities

### Phase 1: MVP (Months 1-2)
1. Core data models and architecture
2. Authentication flow
3. Basic calculator functionality
4. Simple program browsing
5. Mock data for testing

### Phase 2: Enhancement (Months 2-3)
1. AI Match questionnaire
2. Smart search implementation
3. Program comparison
4. User profiles and bookmarks
5. Real university data

### Phase 3: Polish (Months 3-4)
1. Performance optimization
2. Offline functionality
3. Push notifications
4. Analytics integration
5. App Store preparation

## 📈 Success Metrics

### User Engagement
- Daily active users (DAU)
- Session duration
- Feature adoption rates
- Bookmark/save rates
- Search queries per session

### Business Metrics
- App Store rating (target: 4.5+)
- User retention (7-day: 80%+)
- Organic growth rate
- Support ticket volume
- Crash-free rate (99.5%+)

## 🔒 Security & Privacy

### Requirements
- No password storage (Apple Sign In only)
- Encrypted data transmission
- Secure local storage
- Minimal data collection
- Clear privacy policy

### Compliance
- GDPR for EU users
- COPPA for younger users
- App Store privacy requirements
- Polish data protection laws
- Educational data regulations

## 💡 Future Considerations

### Version 2.0
- iPad and Mac support
- University virtual tours
- Student reviews/ratings
- Direct application submission
- Scholarship finder

### Version 3.0
- AI chat assistant
- AR campus tours
- Study buddy matching
- Career path predictions
- International programs

## 🤝 Stakeholder Notes

### For Students
"Make university selection stress-free and transparent"

### For Parents
"Understand and support your child's education journey"

### For Universities
"Connect with qualified, interested candidates"

### For Developers
"Build a maintainable, scalable, delightful app"

---

**Project Start**: December 2024
**Target Launch**: March 2025
**Platform**: iOS (iPhone)
**Market**: Poland