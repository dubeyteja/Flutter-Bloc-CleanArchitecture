#!/bin/bash

# Flutter Feature Migration Validation Script
# This script validates that the Flutter feature migration has been properly implemented

echo "🔍 Validating Flutter Feature Migration Implementation..."
echo ""

# Check if features directory exists
if [ -d "app/lib/features" ]; then
    echo "✅ Features directory exists"
else
    echo "❌ Features directory not found"
    exit 1
fi

# Check if expected features exist
features=("authentication" "home" "product" "profile")
for feature in "${features[@]}"; do
    if [ -d "app/lib/features/$feature" ]; then
        echo "✅ Feature '$feature' exists"
    else
        echo "❌ Feature '$feature' not found"
        exit 1
    fi
done

# Check if presentation layer exists for each feature
for feature in "${features[@]}"; do
    if [ -d "app/lib/features/$feature/presentation" ]; then
        echo "✅ Presentation layer exists for '$feature'"
    else
        echo "❌ Presentation layer not found for '$feature'"
        exit 1
    fi
done

# Check if barrel files exist for each feature
for feature in "${features[@]}"; do
    if [ -f "app/lib/features/$feature/$feature.dart" ]; then
        echo "✅ Barrel file exists for '$feature'"
    else
        echo "❌ Barrel file not found for '$feature'"
        exit 1
    fi
done

# Check if app.dart exports all features
if grep -q "export 'features/authentication/authentication.dart';" app/lib/app.dart && \
   grep -q "export 'features/home/home.dart';" app/lib/app.dart && \
   grep -q "export 'features/product/product.dart';" app/lib/app.dart && \
   grep -q "export 'features/profile/profile.dart';" app/lib/app.dart; then
    echo "✅ App.dart exports all features"
else
    echo "❌ App.dart missing feature exports"
    exit 1
fi

# Check if no ui directory exists (migration completed)
if [ ! -d "app/lib/ui" ]; then
    echo "✅ Old ui directory has been removed"
else
    echo "⚠️  Old ui directory still exists - migration may be incomplete"
fi

# Check import patterns in feature files
echo ""
echo "🔍 Checking import patterns..."

# Find all dart files in features and check import patterns
find app/lib/features -name "*.dart" -not -path "*/bloc/*" | while read -r file; do
    if grep -q "import '../../../app.dart';" "$file"; then
        echo "✅ Correct import pattern in $(basename "$file")"
    elif grep -q "import '../../app.dart';" "$file"; then
        echo "❌ Incorrect import pattern in $file - should be '../../../app.dart'"
    fi
done

# Check if melos.yaml exists for build commands
if [ -f "melos.yaml" ]; then
    echo "✅ Melos configuration exists"
else
    echo "❌ Melos configuration not found"
    exit 1
fi

echo ""
echo "🎉 Flutter Feature Migration validation completed!"
echo ""
echo "📋 Next steps:"
echo "   1. Run 'melos bootstrap' to setup dependencies"
echo "   2. Run 'melos run build_all' to generate code"
echo "   3. Run 'melos run test' to validate tests"
echo "   4. Run 'flutter run' in app directory to test the application"