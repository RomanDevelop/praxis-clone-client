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

## Getting Started

1. Ensure Flutter is installed (v3.0.0 or newer)
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to launch the application

## Technology Stack

- Flutter
- Riverpod for state management
- flutter_map for interactive maps
- CustomPaint for custom UI components
