# Taghyeer Demo - Flutter Technical Assignment (GetX)

A production-quality Flutter application implementing clean architecture, GetX state management, and API integration with DummyJSON.

## Features Implemented

### ✅ Core Requirements
- **User Authentication**: Login with cached session management
- **Bottom Navigation**: 3 tabs (Products, Posts, Settings)
- **Theme Management**: Light/Dark mode with persistence
- **Pagination**: Infinite scroll for products and posts
- **Local Caching**: SharedPreferences for user data and theme
- **Error Handling**: Comprehensive error states with retry mechanisms

### ✅ Architecture
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **GetX State Management**: Reactive state management for all features
- **Repository Pattern**: Abstraction for data sources
- **Dependency Injection**: Proper DI setup with GetX bindings

### ✅ API Integration
- **Authentication**: POST `/auth/login` with proper credentials
- **Products**: GET `/products` with pagination (limit=10, skip=0/10/20...)
- **Posts**: GET `/posts` with pagination (limit=10, skip=0/10/20...)
- **Error Handling**: Network failures, timeouts, and server errors

### ✅ UI/UX Features
- **Login Screen**: Form validation, loading states, error messages
- **Products List**: Card layout with images, prices, brands, infinite scroll
- **Posts List**: Title, body preview, tags, reactions, infinite scroll
- **Settings Screen**: User profile, theme toggle, logout functionality
- **Loading States**: Progress indicators and skeleton loaders
- **Empty/Error States**: Meaningful messages with retry options

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and API endpoints
│   ├── exceptions/         # Custom failure classes
│   ├── services/          # Local storage services
│   └── utils/             # Utility functions
├── data/
│   ├── datasources/
│   │   ├── local/         # SharedPreferences data sources
│   │   └── remote/        # HTTP API data sources
│   ├── models/            # Data transfer objects with JSON serialization
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business objects
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business use cases
├── presentation/
│   ├── controllers/        # GetX controllers (Auth, Product, Post, Theme)
│   ├── screens/           # UI screens
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── products_screen.dart
│   │   ├── posts_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/           # Reusable UI components
└── main.dart              # App initialization and GetX bindings
```

## Technical Implementation

### State Management with GetX
- **AuthController**: Login, logout, session management
- **ProductController**: Product fetching with pagination
- **PostController**: Post fetching with pagination  
- **ThemeController**: Light/dark theme switching

### Data Flow
1. **UI Events** → **GetX Controllers** → **Repository** → **Data Sources**
2. **Data Sources** → **Repository** → **GetX Controllers** → **UI Updates**

### Error Handling
- **Network Failures**: No internet, timeouts
- **Server Errors**: Invalid credentials, API failures
- **Cache Errors**: Local storage issues
- **Validation Errors**: Form input validation

### Pagination
- **GetX Controllers**: Reactive pagination logic
- **Infinite Scroll**: Automatic loading on scroll to bottom
- **Refresh Support**: Pull-to-refresh functionality
- **Loading States**: Distinct loading for initial fetch vs pagination

## Getting Started

### Prerequisites
- Flutter SDK (>=3.11.0)
- Dart SDK
- Android/iOS development environment

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd tagheerDemo
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate JSON serialization code:
```bash
dart run build_runner build
```

4. Run the application:
```bash
flutter run
```

### Default Login Credentials
- **Username**: `emilys`
- **Password**: `emilyspass`

## API Endpoints Used

- **Authentication**: `POST https://dummyjson.com/auth/login`
- **Products**: `GET https://dummyjson.com/products?limit=10&skip=0`
- **Posts**: `GET https://dummyjson.com/posts?limit=10&skip=0`

## Key Dependencies

- `get`: State management and dependency injection
- `get_storage`: Simple local storage
- `http`: HTTP client
- `shared_preferences`: Local storage for caching
- `cached_network_image`: Image caching
- `json_annotation`: JSON serialization
- `connectivity_plus`: Network connectivity

## Production Features

- ✅ Clean Architecture implementation
- ✅ GetX state management
- ✅ Comprehensive error handling
- ✅ Loading and empty states
- ✅ Theme persistence
- ✅ Session management
- ✅ Pagination with infinite scroll
- ✅ Form validation
- ✅ Network image caching
- ✅ Material Design 3
- ✅ Responsive UI

This implementation demonstrates professional Flutter development practices with GetX and meets all requirements of the Taghyeer Technologies technical assignment.
# taghyeerDemo
