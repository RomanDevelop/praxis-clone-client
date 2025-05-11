# 🚢 Ship Monitoring System

An integrated real-time monitoring system for marine engine parameters with alarm generation. Built with **FastAPI** on the backend and **Flutter** on the frontend, designed for use onboard vessels or in simulation environments.

---

## ✨ Features

- Real-time engine data via WebSocket
- Automatic alarm generation based on thresholds
- User switching (e.g., Chief, 2nd Engineer)
- Frontend-ready API for mobile applications
- Easy simulation of engine behavior
- Clean and modular architecture for both server and client

---

## 📁 Project Structure

# Ship Alarm System (Flutter Client)

A Flutter application for monitoring ship engine parameters and systems.

## Architecture

This project follows MVVM (Model-View-ViewModel) architecture and SOLID principles:

### MVVM Components

- **Model**: Domain classes in `lib/src/domain/` directory

  - `app_theme.dart` - Application theme management
  - `navigation_state.dart` - Navigation state model
  - `engine_data.dart` - Engine data models
  - `engine_parameter.dart` - Parameter definitions
  - `system_schema.dart` - System schema models

- **View**: UI components

  - `lib/src/presentation/screens/` - Screen components
  - `lib/src/presentation/widgets/` - Reusable UI components

- **ViewModel**: State management in `lib/src/presentation/viewmodels/`
  - Uses Riverpod for dependency injection and state management
  - Encapsulates business logic separately from UI

### SOLID Principles

- **Single Responsibility Principle**: Each class has one responsibility

  - Example: `ShipWheel` widget only manages wheel rendering
  - Example: `AppTheme` only manages theme configuration

- **Open-Closed Principle**: Code is open for extension, closed for modification

  - Example: `NavigationScreen` enum can be extended with new screens

- **Liskov Substitution Principle**: Derived classes can substitute base classes

  - All widgets follow Flutter widget contract

- **Interface Segregation Principle**: Clients only depend on methods they use

  - ViewModels expose only necessary state and methods

- **Dependency Inversion Principle**: High-level modules don't depend on low-level modules
  - Dependency injection with Riverpod providers

## Features

- Animated splash screen
- Real-time engine parameter monitoring
- Alarm history tracking
- System group visualization
- Interactive engine system diagrams
- Ship position tracking with interactive map
- Dark theme UI with animated components

## Recent Changes

The latest commit represents a major architectural refactoring:

```
commit fe6c0f9
Author: Roman Developer
Date: April 13, 2025

refactor: implement SOLID and MVVM architecture

- Reorganized codebase according to MVVM principles with proper separation of concerns
- Added domain models for navigation state and theme configuration
- Created ViewModels for navigation and splash screen with Riverpod state management
- Extracted reusable components like ShipWheel into separate widget classes
- Implemented dependency injection with Riverpod providers
- Added animated navigation drawer with ship wheel logo
- Integrated ship position screen with interactive map
- Applied Single Responsibility and Open-Closed principles throughout the codebase
- Improved UI/UX with consistent styling and animations
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode for mobile development
- VS Code (recommended) or your preferred IDE

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/ship_alarm_system.git
cd ship_alarm_system/client
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the application:

```bash
flutter run
```

## 🔧 Development

### Mock Data Mode

The application can run in two modes:

1. **WebSocket Mode**: Connects to a real backend server
2. **Mock Data Mode**: Uses simulated data for UI testing

To switch between modes, modify `lib/src/shared/providers.dart`:

```dart
// WebSocket Mode
final engineSocketProvider = Provider((ref) => EngineSocketClient(socketUrl));

// Mock Data Mode
final engineSocketProvider = Provider((ref) => null);
```

### Backend Integration

The backend should provide a WebSocket endpoint at `ws://your-server:8000/ws/engine` with the following data structure:

```json
{
  "rpm": 750.0,
  "engine_load": 85.0,
  "oil_temperature": 85.0,
  "oil_pressure": 3.0,
  "coolant_temperature": 90.0,
  "coolant_pressure": 1.0,
  "fuel_pressure": 3.0,
  "fuel_consumption": 8.5,
  "exhaust_temp_1": 450.0,
  "exhaust_temp_2": 445.0,
  "exhaust_temp_3": 448.0,
  "exhaust_temp_4": 452.0,
  "exhaust_temp_5": 447.0,
  "turbo_pressure": 5.0,
  "air_intake_temp": 35.0,
  "battery_voltage": 24.0,
  "oil_level": 85.0,
  "coolant_level": 90.0,
  "fuel_level": 75.0,
  "engine_hours": 1250.5,
  "timestamp": "2024-03-20T10:30:00Z"
}
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
