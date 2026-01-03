# 🌱 Eco Track - Carbon Footprint Tracker

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue)

A beautiful, cross-platform Flutter application for tracking carbon footprint, finding recycling points, and completing eco-friendly challenges.

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Architecture](#️-architecture) • [Contributing](#-contributing)

</div>

---

## 📱 About

Eco Track is a modern Flutter application designed to help users track their environmental impact, find nearby recycling centers, and participate in eco-friendly challenges. Built with clean architecture principles, it demonstrates professional Flutter development practices suitable for portfolio presentation.

### Key Highlights

- ✨ **Modern UI/UX**: Beautiful, adaptive interface with smooth animations
- 🌍 **Multi-language**: English, Russian, and Spanish support
- 🎨 **Customizable Themes**: Multiple color palettes and dark mode
- 🔥 **Firebase Integration**: Authentication, Firestore, and real-time data
- 🗺️ **OpenStreetMap**: Free, open-source map integration
- 📊 **Data Visualization**: Interactive charts and statistics
- 🏆 **Gamification**: Challenges and achievements system

## 🌟 Features

### Core Functionality

- **Carbon Footprint Calculator**
  - Calculate environmental impact based on transport, energy, diet, and waste
  - Detailed breakdown by category
  - Personalized recommendations
  - Historical tracking

- **Recycling Points Map**
  - Interactive map with OpenStreetMap
  - Filter by waste type (plastic, glass, electronics, etc.)
  - Location-based search
  - Detailed point information

- **Eco Challenges**
  - Daily, weekly, and monthly challenges
  - Points and rewards system
  - Progress tracking
  - Achievement unlocks

- **User Profile**
  - Statistics and analytics
  - Achievement gallery
  - Theme customization
  - Settings management

### Technical Features

- **Authentication**
  - Email/Password authentication
  - Google Sign-In
  - Demo mode for testing
  - Secure session management

- **State Management**
  - BLoC pattern for predictable state
  - Reactive UI updates
  - Efficient data flow

- **Localization**
  - English (en)
  - Russian (ru)
  - Spanish (es)
  - Easy to add more languages

- **Theming**
  - 3 color palettes (Eco, Minimalist, Vibrant)
  - Light/Dark/System theme modes
  - Dynamic theme switching

## 📸 Screenshots

*Add screenshots of your app here*

## 🏗️ Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App-wide constants
│   ├── theme/              # Theme configuration
│   ├── utils/              # Utility functions and extensions
│   └── widgets/            # Reusable widgets
├── features/               # Feature modules (Clean Architecture)
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Data layer (models, repositories, datasources)
│   │   ├── domain/        # Domain layer (entities, use cases)
│   │   └── presentation/   # Presentation layer (pages, widgets, bloc)
│   ├── calculator/        # Carbon footprint calculator
│   ├── map/               # Recycling points map
│   ├── home/              # Home screen with challenges
│   ├── profile/           # User profile and settings
│   └── onboarding/        # Onboarding screens
├── app.dart               # Main app widget
└── main.dart              # Entry point
```

### State Management

- **BLoC Pattern**: Used for managing application state
- **Cubit/Bloc**: For feature-specific state management
- **GetIt**: For dependency injection (planned)

### Design Patterns

- **Repository Pattern**: Abstraction layer for data sources
- **Factory Pattern**: For creating models from different sources
- **Observer Pattern**: BLoC streams for reactive updates

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK (3.0+)
- Android Studio / Xcode (for mobile development)
- Firebase account (for authentication and backend)

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/rafaelwww07-ios/eco-track.git
cd eco-track
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate code (if needed):**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase Setup

1. **Create a Firebase project:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project

2. **Add your apps:**
   - **Android**: Add package name from `android/app/build.gradle.kts`
   - **iOS**: Add bundle ID from `ios/Runner.xcodeproj`

3. **Download configuration files:**
   - **Android**: Download `google-services.json` → place in `android/app/`
   - **iOS**: Download `GoogleService-Info.plist` → place in `ios/Runner/`

4. **Enable Authentication:**
   - Go to Firebase Console → Authentication → Sign-in method
   - Enable **Email/Password**
   - Enable **Google Sign-In** (configure OAuth consent screen)

5. **Create Firestore Database:**
   - Go to Firebase Console → Firestore Database
   - Create database in test mode (or production with proper rules)
   - The app will automatically initialize default challenge data on first launch

6. **Configure Firebase Options:**
   - Run `flutterfire configure` (if Firebase CLI is installed)
   - Or manually update `lib/firebase_options.dart` with your project configuration

### Running the App

**Android:**
```bash
# Launch emulator (if not running)
./launch_emulator.sh

# Or run directly
flutter run -d android
```

**iOS:**
```bash
# Launch simulator (if not running)
./launch_ios.sh

# Or run directly
flutter run -d ios
```

**Or use the helper scripts:**
```bash
./run_app.sh      # Android
./run_ios.sh       # iOS
```

## 📦 Dependencies

### Core
- `flutter_bloc` - State management
- `equatable` - Value equality
- `get_it` - Dependency injection

### Firebase
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - NoSQL database
- `google_sign_in` - Google Sign-In

### UI & Design
- `lottie` - Animations
- `fl_chart` - Charts and graphs
- `shimmer` - Loading skeletons
- `flutter_map` - OpenStreetMap integration
- `latlong2` - Geographic coordinates

### Utilities
- `geolocator` - Location services
- `geocoding` - Address geocoding
- `shared_preferences` - Local storage
- `hive` - Local database
- `workmanager` - Background tasks
- `vibration` - Haptic feedback
- `intl` - Internationalization

## 🧪 Testing

Run tests with:
```bash
flutter test
```

The project includes:
- Unit tests for business logic
- Widget tests for UI components
- BLoC tests for state management

## 📱 Platform Support

- ✅ **iOS** (14.0+)
- ✅ **Android** (API 21+)
- ⚠️ **Web** (partial support, demo mode available)
- ❌ **Desktop** (not tested)

## 🎨 Design System

The app uses a custom design system with:

- **3 Color Palettes**:
  - 🌿 **Eco**: Green-based, nature-inspired
  - ⚪ **Minimalist**: Clean, monochrome
  - 🌈 **Vibrant**: Colorful, energetic

- **Theme Modes**: Light, Dark, System
- **Material Design 3**: Modern Material Design components
- **Adaptive UI**: Responsive layouts for different screen sizes

## 🌍 Localization

Currently supported languages:
- 🇬🇧 English (en)
- 🇷🇺 Russian (ru)
- 🇪🇸 Spanish (es)

To add a new language:
1. Create `l10n/app_XX.arb` file
2. Add translations
3. Run `flutter pub get` to generate localization files

## 🔐 Demo Mode

The app includes a demo mode that allows users to explore features without authentication. Access it from the login screen.

## 📝 Code Style

- Follows Flutter/Dart style guidelines
- Uses `flutter_lints` for code analysis
- Comprehensive comments in English
- Null-safe code throughout
- Modern Dart features (extensions, async/await)

## 🤝 Contributing

This is a portfolio project, but suggestions and improvements are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Rafael Mukhametov**

- Portfolio: [Upwork Profile](https://www.upwork.com/freelancers/~your-profile)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Design inspiration from "JouleBug" and "Forest" apps
- Maps implementation using OpenStreetMap
- Icons and assets from various open-source projects

## 📊 Project Status

✅ **Core Features**: Complete
✅ **Firebase Integration**: Complete
✅ **UI/UX**: Complete
✅ **Localization**: English, Russian, Spanish
✅ **Testing**: Basic tests implemented
🔄 **Future Enhancements**: See [Issues](https://github.com/rafaelwww07-ios/eco-track/issues)

---

<div align="center">

Made with ❤️ using Flutter

⭐ Star this repo if you find it helpful!

</div>
