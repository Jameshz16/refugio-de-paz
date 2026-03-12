---
name: accessibility
description: "Accessibility (a11y) best practices for Flutter apps. Covers Semantics widgets, screen readers, color contrast, touch targets, and automated a11y testing. Use when building inclusive mobile experiences."
version: 1.0.0
tags: [accessibility, a11y, semantics, screen-reader, flutter, inclusive-design]
---

# Accessibility (a11y) for Flutter

> **Rule:** If someone can't use your app, your design has failed — not the user.

---

## 1. Why It Matters

- **15% of the world** has some form of disability
- **Google Play & App Store** reward accessible apps with better rankings
- **Many countries** have legal requirements (ADA, EU Accessibility Act)
- It's the **right thing to do**

---

## 2. Semantics Widget (Screen Reader Support)

### Label Interactive Elements

```dart
// ❌ BAD: Screen reader says nothing useful
IconButton(
  icon: const Icon(Icons.favorite),
  onPressed: _toggleFavorite,
)

// ✅ GOOD: Screen reader says "Guardar en favoritos"
Semantics(
  label: 'Guardar en favoritos',
  button: true,
  child: IconButton(
    icon: const Icon(Icons.favorite),
    onPressed: _toggleFavorite,
    tooltip: 'Guardar en favoritos',
  ),
)
```

### Label Images

```dart
Semantics(
  label: 'Emoji de persona feliz',
  child: Text('😊', style: TextStyle(fontSize: 48)),
)
```

### Exclude Decorative Elements

```dart
Semantics(
  excludeSemantics: true,
  child: DecorativeBackground(),
)
```

---

## 3. Color Contrast

### Minimum Ratios (WCAG 2.1)

| Element              | Minimum Ratio |
| -------------------- | ------------- |
| Normal text          | **4.5:1**     |
| Large text (18sp+)   | **3:1**       |
| Interactive elements | **3:1**       |

### Check Your Colors

```dart
// Use this to verify during development
import 'package:flutter/material.dart';

bool hasGoodContrast(Color foreground, Color background) {
  final luminance1 = foreground.computeLuminance();
  final luminance2 = background.computeLuminance();
  final brightest = luminance1 > luminance2 ? luminance1 : luminance2;
  final darkest = luminance1 > luminance2 ? luminance2 : luminance1;
  final ratio = (brightest + 0.05) / (darkest + 0.05);
  return ratio >= 4.5;
}
```

---

## 4. Touch Targets

```dart
// ❌ BAD: Too small (24x24)
SizedBox(
  width: 24,
  height: 24,
  child: IconButton(icon: Icon(Icons.close), onPressed: _close),
)

// ✅ GOOD: Minimum 48x48 dp
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(icon: Icon(Icons.close), onPressed: _close),
)
```

> **Minimum touch target: 48x48 dp** (Android) / **44x44 pt** (iOS)

---

## 5. Text Scaling

```dart
// ✅ Respect user's text size preferences
Text(
  'Versículo del día',
  style: Theme.of(context).textTheme.bodyLarge,
  // Flutter respects MediaQuery.textScaleFactor by default
)

// ❌ Never set a hardcoded textScaleFactor
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), // DON'T
  child: child,
)
```

---

## 6. Focus & Navigation Order

```dart
// Control focus order for keyboard/switch users
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(
    children: [
      FocusTraversalOrder(
        order: const NumericFocusOrder(1),
        child: EmotionSelector(),
      ),
      FocusTraversalOrder(
        order: const NumericFocusOrder(2),
        child: TextInput(),
      ),
      FocusTraversalOrder(
        order: const NumericFocusOrder(3),
        child: SubmitButton(),
      ),
    ],
  ),
)
```

---

## 7. Testing Accessibility

### Automated Testing

```dart
testWidgets('home screen has good semantics', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

  // Verify semantic labels exist
  expect(
    tester.getSemantics(find.byIcon(Icons.favorite)),
    matchesSemantics(label: 'Guardar en favoritos'),
  );
});
```

### Manual Testing Checklist

- [ ] Enable TalkBack (Android) / VoiceOver (iOS) and navigate the entire app
- [ ] Verify every interactive element has a spoken label
- [ ] Increase text size to 200% and check layout doesn't break
- [ ] Navigate using only a keyboard (if applicable)
- [ ] Check color contrast with a tool (e.g., Accessibility Scanner)

---

## 8. Quick Wins Checklist

- [ ] All `IconButton`s have a `tooltip`
- [ ] All images have semantic labels
- [ ] Touch targets ≥ 48dp
- [ ] Text contrast ≥ 4.5:1
- [ ] App respects system text scaling
- [ ] Decorative elements excluded from semantics
- [ ] Focus order is logical

---

## When to Use

Apply from the first screen you build. Accessibility is not a feature — it's a quality standard.
