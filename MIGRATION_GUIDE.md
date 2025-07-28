# Migration Guide: Layer-First to Feature-First Architecture

This guide helps developers understand the changes made to convert the project from layer-first to feature-first architecture.

## What Changed

### Directory Structure

**Before:**
```
app/lib/
├── ui/
│   ├── home/
│   ├── login/
│   ├── search/
│   ├── item_detail/
│   ├── my_page/
│   └── main/
├── base/
├── config/
├── di/
└── navigation/
```

**After:**
```
app/lib/
├── features/
│   ├── authentication/
│   │   └── presentation/
│   ├── home/
│   │   └── presentation/
│   ├── product/
│   │   └── presentation/
│   └── profile/
│       └── presentation/
├── base/
├── config/
├── di/
└── navigation/
```

### Feature Mapping

| Old Location | New Location | Description |
|--------------|--------------|-------------|
| `ui/login/` | `features/authentication/presentation/` | Login and auth flows |
| `ui/home/` | `features/home/presentation/` | Home page |
| `ui/main/` | `features/home/presentation/` | Main app shell |
| `ui/search/` | `features/product/presentation/` | Product search |
| `ui/item_detail/` | `features/product/presentation/` | Product details |
| `ui/my_page/` | `features/profile/presentation/` | User profile |

## Import Changes

### Updated Imports
All files moved to features now use:
```dart
import '../../../app.dart';  // Instead of '../../app.dart'
```

### Feature Exports
Each feature now has a barrel file:
- `features/authentication/authentication.dart`
- `features/home/home.dart`
- `features/product/product.dart`
- `features/profile/profile.dart`

## Working with the New Structure

### Adding a New Feature
1. Create feature directory: `features/my_feature/`
2. Add presentation layer: `features/my_feature/presentation/`
3. Add domain logic (if needed): `features/my_feature/domain/`
4. Add data layer (if needed): `features/my_feature/data/`
5. Create barrel file: `features/my_feature/my_feature.dart`
6. Export in main `app.dart`

### Adding Feature-Specific Logic
- **Domain**: Feature-specific use cases and entities
- **Data**: Feature-specific repositories and data sources
- **Presentation**: UI components, pages, and BLoCs

### Shared Code Guidelines
- Use `shared/` module for cross-cutting utilities
- Use `resources/` for app-wide resources
- Keep core domain entities in root `domain/` module
- Avoid feature-to-feature dependencies

## Breaking Changes

### Code Generation
- Run `melos run build_all` to regenerate files after migration
- Update any custom scripts that reference old paths

### Tests
- Update test imports to reference new feature paths
- Feature tests can now be co-located with features

### Navigation
- No changes to routing - all pages are exported through features
- Routes continue to work as before

## Benefits Realized

1. **Better Organization**: Code is grouped by business functionality
2. **Feature Independence**: Each feature is self-contained
3. **Team Scalability**: Multiple teams can work on different features
4. **Easier Onboarding**: New developers can focus on specific features
5. **Future Extraction**: Features can become separate packages

## Rollback Instructions

If needed, to rollback the changes:
1. Restore the `ui/` directory structure
2. Move files back from `features/*/presentation/` to `ui/*/`
3. Revert import path changes
4. Update `app.dart` exports
5. Run `melos run build_all`

However, the new structure is recommended for better maintainability and scalability.