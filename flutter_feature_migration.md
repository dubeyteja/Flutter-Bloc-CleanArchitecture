# Flutter Feature Migration Guide

## Overview

This document provides Flutter-specific guidance for migrating from a layer-first to feature-first architecture in the Flutter Clean Architecture project. It complements the general [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) with Flutter-specific implementation details.

## Flutter Widget Organization

### Before Migration (Layer-First)
```
app/lib/ui/
├── home/
│   ├── home_page.dart
│   └── bloc/
├── login/
│   ├── login_page.dart
│   └── bloc/
├── search/
│   ├── search_page.dart
│   └── bloc/
└── item_detail/
    ├── item_detail_page.dart
    └── bloc/
```

### After Migration (Feature-First)
```
app/lib/features/
├── authentication/
│   ├── presentation/
│   │   ├── login_page.dart
│   │   └── bloc/
│   └── authentication.dart
├── home/
│   ├── presentation/
│   │   ├── home_page.dart
│   │   ├── main_page.dart
│   │   └── bloc/
│   └── home.dart
├── product/
│   ├── presentation/
│   │   ├── search_page.dart
│   │   ├── item_detail_page.dart
│   │   └── bloc/
│   └── product.dart
└── profile/
    ├── presentation/
    │   ├── my_page_page.dart
    │   └── bloc/
    └── profile.dart
```

## Flutter-Specific Import Changes

### Widget Import Pattern
All Flutter widgets in features now use the standardized import pattern:

```dart
// Before (in ui/ structure)
import '../../app.dart';

// After (in features/*/presentation/ structure)
import '../../../app.dart';
```

### Example Widget Implementation
```dart
// features/authentication/presentation/login_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';

import '../../../app.dart';  // Standardized app import
import 'bloc/login.dart';    // Feature-specific BLoC

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage, LoginBloc> {
  // Widget implementation
}
```

## BLoC Pattern in Features

### BLoC Organization
Each feature contains its BLoCs within the presentation layer:

```
features/authentication/presentation/bloc/
├── login_bloc.dart
├── login_event.dart
├── login_state.dart
└── login.dart (barrel file)
```

### BLoC Export Pattern
Feature barrel files export all presentation components:

```dart
// features/authentication/authentication.dart
export 'presentation/login_page.dart';
export 'presentation/bloc/login.dart';
```

### BLoC Dependency Injection
BLoCs are registered in the DI container and can access domain/data layers:

```dart
// BLoC can depend on use cases from domain layer
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  final AuthenticationUseCase _authUseCase;
  
  LoginBloc(this._authUseCase) : super(const LoginState.initial());
}
```

## Flutter Routing Integration

### Route Configuration
The AutoRoute configuration remains unchanged, but pages are now exported from features:

```dart
// app/lib/navigation/routes/app_router.dart
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Routes reference feature exports
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
    ),
    // ... other routes
  ];
}
```

### Page Registration
Pages are automatically available through feature exports in app.dart:

```dart
// app/lib/app.dart
export 'features/authentication/authentication.dart';
export 'features/home/home.dart';
export 'features/product/product.dart';
export 'features/profile/profile.dart';
```

## Asset Management

### Feature-Specific Assets
While app-wide assets remain in `app/assets/`, feature-specific assets can be organized alongside features:

```
features/authentication/
├── presentation/
│   ├── assets/          # Feature-specific assets (optional)
│   │   └── login_icon.svg
│   └── widgets/
└── authentication.dart
```

### Asset Access
Assets are accessed through the generated assets file:

```dart
// Using app-wide assets
import 'package:resources/resources.dart';

// In widget
Assets.images.logo.image()
```

## Flutter Testing

### Test Organization
Tests can be co-located with features or remain in the central test directory:

```
test/
├── features/
│   ├── authentication/
│   │   ├── presentation/
│   │   │   ├── login_page_test.dart
│   │   │   └── bloc/
│   │   │       └── login_bloc_test.dart
│   │   └── authentication_test.dart
│   └── home/
│       └── presentation/
└── integration_test/
```

### Widget Test Example
```dart
// test/features/authentication/presentation/login_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/lib/app.dart'; // Import from app

void main() {
  group('LoginPage', () {
    testWidgets('should display login form', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(),
            child: const LoginPage(),
          ),
        ),
      );
      
      expect(find.byType(TextField), findsWidgets);
    });
  });
}
```

### BLoC Test Example
```dart
// test/features/authentication/presentation/bloc/login_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../app/lib/app.dart';

void main() {
  group('LoginBloc', () {
    blocTest<LoginBloc, LoginState>(
      'emits success when login succeeds',
      build: () => LoginBloc(mockAuthUseCase),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [isA<LoginSuccess>()],
    );
  });
}
```

## Flutter Build Process

### Code Generation
Run code generation after migration to update generated files:

```bash
# Generate all code (routes, assets, etc.)
melos run build_all

# Or run specific generators
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Build Commands
The existing Flutter build commands remain unchanged:

```bash
# Development build
flutter run

# Release build
flutter build apk --release
flutter build ios --release

# Web build
flutter build web --release
```

## State Management with Features

### BLoC Provider Setup
Each feature's BLoCs are provided through the DI container:

```dart
// Dependency injection setup
GetIt.instance.registerFactory<LoginBloc>(
  () => LoginBloc(GetIt.instance<AuthenticationUseCase>()),
);

// In app widget tree
BlocProvider<LoginBloc>(
  create: (_) => GetIt.instance<LoginBloc>(),
  child: LoginPage(),
)
```

### Feature Communication
Features communicate through shared domain layer or events:

```dart
// Avoid direct feature-to-feature dependencies
// Instead, use domain events or shared state
class SharedAppBloc extends Bloc<AppEvent, AppState> {
  // Handle cross-feature communication
}
```

## Theming and Styling

### Theme Access
Themes and styles remain app-wide and are accessed consistently:

```dart
// In any feature widget
@override
Widget build(BuildContext context) {
  return Container(
    color: context.appColors.primary, // From resources package
    child: Text(
      'Feature Content',
      style: context.appTextStyles.titleLarge,
    ),
  );
}
```

## Performance Considerations

### Lazy Loading
Features can be lazily loaded to improve app startup time:

```dart
// Use deferred imports for large features
import 'package:app/features/product/product.dart' deferred as product;

// Load when needed
await product.loadLibrary();
```

### Bundle Optimization
Consider feature-based code splitting for web builds:

```bash
flutter build web --split-debug-info=./debug-info/
```

## Migration Checklist

### Flutter-Specific Migration Steps

- [x] Move Flutter pages from `ui/` to `features/*/presentation/`
- [x] Update all widget import paths to use `../../../app.dart`
- [x] Create feature barrel files exporting all presentation components
- [x] Update BLoC imports and registrations
- [x] Verify AutoRoute page registrations work with new exports
- [x] Update test imports to reference new feature paths
- [x] Run code generation to update generated files
- [x] Test all Flutter routes and navigation
- [x] Verify hot reload works correctly with new structure
- [x] Test Flutter widget rendering and state management

### Validation Commands

```bash
# Analyze Flutter code
flutter analyze

# Run Flutter tests
flutter test

# Verify hot reload
flutter run --hot

# Check build works
flutter build apk --debug
```

## Troubleshooting

### Common Flutter Issues

1. **Import Path Errors**
   ```dart
   // Wrong
   import '../../app.dart';
   
   // Correct
   import '../../../app.dart';
   ```

2. **Route Not Found**
   - Ensure feature barrel files export all pages
   - Verify app.dart includes feature exports
   - Check AutoRoute configuration

3. **BLoC Not Found**
   - Verify BLoC is registered in DI container
   - Check feature barrel exports include BLoC
   - Ensure proper provider setup

4. **Hot Reload Issues**
   - Restart app if hot reload fails after migration
   - Clear Flutter build cache: `flutter clean`
   - Regenerate code: `flutter packages pub run build_runner clean`

## Future Flutter Enhancements

### Potential Improvements

1. **Feature Modules**: Extract features as separate Flutter packages
2. **Micro-Frontends**: Use Flutter's plugin architecture for feature isolation
3. **Dynamic Features**: Implement dynamic feature loading for Android
4. **Web Code Splitting**: Optimize bundle size with feature-based splits
5. **Feature Flags**: Implement Flutter feature toggles for gradual rollouts

## Conclusion

The Flutter feature migration provides better organization while maintaining all Flutter-specific functionality. The new structure supports:

- Better Flutter widget organization by business logic
- Improved BLoC pattern implementation
- Scalable Flutter app architecture
- Enhanced testing capabilities
- Future Flutter feature extraction possibilities

For general migration details, refer to [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) and [FEATURE_FIRST_ARCHITECTURE.md](FEATURE_FIRST_ARCHITECTURE.md).