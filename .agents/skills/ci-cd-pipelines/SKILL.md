---
name: ci-cd-pipelines
description: "CI/CD pipeline setup for Flutter apps. Covers GitHub Actions, Codemagic, Fastlane, automated testing, code signing, and store deployment. Use when automating builds, tests, or app store submissions."
version: 1.0.0
tags: [ci-cd, github-actions, codemagic, fastlane, deployment, flutter]
---

# CI/CD Pipelines for Flutter

> **Rule:** If you deploy manually, you will eventually deploy a broken build.

---

## 1. GitHub Actions (Recommended for Free Tier)

### Test on Every Push

```yaml
# .github/workflows/test.yml
name: Flutter Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"
          channel: "stable"

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze code
        run: flutter analyze --fatal-infos

      - name: Run tests
        run: flutter test --coverage

      - name: Check coverage
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')
          echo "Coverage: $COVERAGE%"
```

### Build Android APK

```yaml
# .github/workflows/build-android.yml
name: Build Android

on:
  push:
    tags: ["v*"]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"

      - name: Build APK
        run: |
          flutter build apk --release \
            --obfuscate \
            --split-debug-info=./debug-info/ \
            --dart-define=DEEPSEEK_API_KEY=${{ secrets.DEEPSEEK_API_KEY }} \
            --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
            --dart-define=SUPABASE_KEY=${{ secrets.SUPABASE_KEY }}

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk

      - name: Upload debug info
        uses: actions/upload-artifact@v4
        with:
          name: debug-info
          path: debug-info/
```

---

## 2. Codemagic (Best for iOS Builds)

### codemagic.yaml

```yaml
workflows:
  release:
    name: Release Build
    max_build_duration: 60
    environment:
      flutter: stable
      vars:
        DEEPSEEK_API_KEY: Encrypted(...)
        SUPABASE_URL: Encrypted(...)
        SUPABASE_KEY: Encrypted(...)
      ios_signing:
        provisioning_profiles:
          - profile_name
        certificates:
          - certificate_name

    scripts:
      - name: Get dependencies
        script: flutter pub get
      - name: Run tests
        script: flutter test
      - name: Build iOS
        script: |
          flutter build ipa --release \
            --obfuscate \
            --split-debug-info=./debug-info/ \
            --dart-define=DEEPSEEK_API_KEY=$DEEPSEEK_API_KEY

    artifacts:
      - build/ios/ipa/*.ipa
      - debug-info/**

    publishing:
      app_store_connect:
        auth: integration
        submit_to_testflight: true
```

---

## 3. Fastlane (Store Automation)

### Android

```ruby
# android/fastlane/Fastfile
default_platform(:android)

platform :android do
  lane :deploy do
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab',
    )
  end
end
```

### iOS

```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  lane :beta do
    build_app(scheme: "Runner", export_method: "app-store")
    upload_to_testflight
  end
end
```

---

## 4. Pipeline Best Practices

### Branch Strategy

```
main       → Production (auto-deploy to stores)
develop    → Staging (auto-deploy to TestFlight/Internal)
feature/*  → Tests only (PR checks)
```

### Secrets Management

- **Never** commit secrets to git
- Use GitHub Secrets, Codemagic Encrypted vars
- Pass via `--dart-define` at build time

### Versioning

```bash
# Bump version before release
# pubspec.yaml: version: 1.2.0+15
#                        ^^^^^  ^^
#                        name   build number
```

---

## 5. Release Checklist

- [ ] All tests pass
- [ ] Code analyzed without warnings
- [ ] Version bumped in `pubspec.yaml`
- [ ] Changelog updated
- [ ] Build obfuscated
- [ ] Debug symbols uploaded (for crash reports)
- [ ] Secrets injected via CI (not hardcoded)
- [ ] Tested on physical device

---

## When to Use

Set up CI/CD as soon as the project has its first test. Automate early, deploy often.
