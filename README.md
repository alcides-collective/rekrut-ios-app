# Rekrut - iOS App for Polish University Applicants

<p align="center">
  <img src="https://rekrut.app/logo.png" alt="Rekrut Logo" width="120">
</p>

<p align="center">
  <strong>🎓 Your AI-powered university admission assistant for Poland</strong>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#installation">Installation</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#contributing">Contributing</a>
</p>

## 📱 About Rekrut

Rekrut is an iOS application designed to help Polish high school students navigate the complex university admission process. With personalized recommendations, real-time point calculations, and AI-powered matching, Rekrut makes finding your dream university program simple and stress-free.

### 🌟 Key Features

- **🧮 Interactive Matura Calculator** - Visual progress bars show your admission chances in real-time
- **🤖 AI Match Questionnaire** - Get personalized program recommendations based on your interests and goals
- **🔍 Smart Search** - Find programs and universities instantly with intelligent search
- **📊 Dynamic Point Calculation** - Automatic calculation using each university's unique admission formula
- **🏫 Explore Universities** - Browse top Polish universities with detailed program information
- **📌 Bookmarks** - Save your favorite programs and track application deadlines
- **🌍 Erasmus+ Programs** - Discover international exchange opportunities
- **📈 Rekrut Score™** - Our proprietary 0-100 scoring system for easy comparison

## 🚀 Getting Started

### Prerequisites

- macOS 11.0 or later
- Xcode 13.0 or later
- iOS 15.0+ deployment target
- CocoaPods or Swift Package Manager

### Installation

1. Clone the repository:
```bash
git clone git@github.com:alcides-collective/rekrut-ios-app.git
cd rekrut-ios-app
```

2. Open the project in Xcode:
```bash
open Rekrut/Rekrut.xcodeproj
```

3. Configure Firebase:
   - Add your `GoogleService-Info.plist` to the project
   - Enable Authentication and Firestore in Firebase Console

4. Build and run:
   - Select your target device/simulator
   - Press `Cmd+R` to run

## 🛠 Tech Stack

- **Language**: Swift 5
- **UI Framework**: SwiftUI
- **Architecture**: MVVM
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Authentication**: Sign in with Apple
- **Minimum iOS**: 16.0
- **Dependencies**: Firebase SDK

## 📂 Project Structure

```
Rekrut/
├── App/                    # App entry point and configuration
├── Models/                 # Data models (University, StudyProgram, etc.)
├── Views/                  # SwiftUI views organized by feature
│   ├── Auth/              # Authentication screens
│   ├── Calculator/        # Matura calculator
│   ├── Explore/           # University browsing
│   ├── Search/            # Smart search
│   ├── AIMatch/           # AI questionnaire
│   └── Profile/           # User profile and bookmarks
├── ViewModels/            # Business logic and state management
├── Services/              # Firebase, API, and utility services
└── Resources/             # Assets, fonts, and configuration files
```

## 🎨 Design Principles

- **Polish-first UI**: All interface text in Polish
- **iOS Native Patterns**: Following Apple's Human Interface Guidelines
- **Compact & Efficient**: Minimizing taps and vertical scrolling
- **Visual Feedback**: Progress indicators and animations
- **Accessibility**: VoiceOver support and dynamic type

## 🔒 Privacy & Security

- **Apple Sign In**: Secure authentication without password management
- **Data Encryption**: All user data encrypted in transit and at rest
- **Minimal Permissions**: Only requesting necessary device capabilities
- **GDPR Compliant**: User data handling follows EU regulations

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Create a feature branch from `main`
2. Make your changes following our code style
3. Test on iOS 15.0 simulator minimum
4. Submit a pull request with clear description

### Code Style

- SwiftUI preferred over UIKit
- MVVM architecture pattern
- Async/await for asynchronous code
- Polish for UI text, English for code

## 📄 License

This project is proprietary software. All rights reserved by Alcides Collective.

## 📞 Contact

- **Website**: [rekrut.app](https://rekrut.app)
- **Email**: support@rekrut.app
- **Issues**: [GitHub Issues](https://github.com/alcides-collective/rekrut-ios-app/issues)

---

<p align="center">
  Made with ❤️ for Polish students by <a href="https://alcides.co">Alcides Collective</a>
</p>