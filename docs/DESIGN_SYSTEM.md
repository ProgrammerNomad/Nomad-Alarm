# Design System

Material 3 design specification for Nomad Alarm. All UI must follow these tokens for consistency across screens, widgets, and notifications.

See also: [Screens](SCREENS.md), [Assets](ASSETS.md), [Sounds](SOUNDS.md).

---

## Design Principles

1. **Clarity over decoration** - distance and ETA are the hero information
2. **Calm when tracking, urgent when ringing** - two visual modes
3. **One-hand friendly** - primary actions reachable at bottom
4. **Accessible by default** - contrast, touch targets, TalkBack labels
5. **Material 3 native** - use theme tokens, not hardcoded colors in widgets

---

## Color Palette

### Brand & Semantic

| Token | Hex | Use |
|-------|-----|-----|
| `primary` | `#1565C0` | Logo pin blue - FAB, buttons, active nav |
| `onPrimary` | `#FFFFFF` | Logo bell white - text/icons on primary |
| `primaryContainer` | `#E3F2FD` | Selected chips, subtle highlights |
| `onPrimaryContainer` | `#0D47A1` | Text on primary container |
| `secondary` | `#00C853` | Success, approaching destination, active GPS |
| `onSecondary` | `#FFFFFF` | Text on secondary |
| `secondaryContainer` | `#E8F5E9` | Success banners |
| `tertiary` | `#7C4DFF` | Favorites, accents |
| `error` | `#D32F2F` | Errors, missed alarms, GPS lost |
| `onError` | `#FFFFFF` | Text on error |
| `errorContainer` | `#FFEBEE` | Error banners |
| `warning` | `#F57C00` | Low battery, permission warnings |
| `surface` | `#FAFAFA` (light) / `#121212` (dark) | Screen background |
| `surfaceContainer` | `#F5F5F5` (light) / `#1E1E1E` (dark) | Cards |
| `onSurface` | `#1A1A1A` (light) / `#E0E0E0` (dark) | Primary text |
| `onSurfaceVariant` | `#616161` | Secondary text, captions |
| `outline` | `#BDBDBD` | Borders, dividers |

### User-Selectable Accent Colors

| Name | Hex |
|------|-----|
| Blue (default) | `#1565C0` |
| Green | `#00C853` |
| Orange | `#FF6D00` |
| Purple | `#7C4DFF` |
| Red | `#D32F2F` |

Accent replaces `primary` / `primaryContainer` pair when selected in Settings.

### Alarm Ring Mode

When alarm is ringing, temporarily override theme:

| Token | Value |
|-------|-------|
| Background | `#B71C1C` → `#D32F2F` gradient |
| Text | `#FFFFFF` |
| Action buttons | High contrast white outline |

---

## Typography

### Font Families

| Role | Primary | Fallback |
|------|---------|----------|
| Default | Inter | Roboto |
| Alternative | Manrope | Roboto |
| System | Roboto | Platform default |

User selects in Settings; default is **Inter**.

### Type Scale (Material 3)

| Style | Size | Weight | Line Height | Use |
|-------|------|--------|-------------|-----|
| `displayLarge` | 57 sp | 400 | 64 | Alarm ring distance |
| `displayMedium` | 45 sp | 400 | 52 | Active alarm distance |
| `headlineLarge` | 32 sp | 600 | 40 | Screen titles |
| `headlineMedium` | 28 sp | 600 | 36 | Section headers |
| `titleLarge` | 22 sp | 600 | 28 | Card titles, destination name |
| `titleMedium` | 16 sp | 600 | 24 | List item titles |
| `bodyLarge` | 16 sp | 400 | 24 | Body text |
| `bodyMedium` | 14 sp | 400 | 20 | Secondary info |
| `labelLarge` | 14 sp | 600 | 20 | Buttons |
| `labelMedium` | 12 sp | 600 | 16 | Chips, badges |
| `labelSmall` | 11 sp | 500 | 16 | Captions, timestamps |

### Rules

* Minimum body text: **14 sp** (respect system scaling)
* Distance/ETA on Active Alarm: `displayMedium` or larger
* Never use more than **2 font weights** on one screen

---

## Iconography

### Library

**Primary:** Material Symbols (Rounded variant)

**Alternative:** Huge Icons (if bundled size permits)

### Sizes

| Context | Size |
|---------|------|
| Navigation bar | 24 dp |
| List leading | 24 dp |
| FAB | 24 dp |
| Inline action | 20 dp |
| Empty state hero | 64 dp |
| Alarm ring | 80 dp |

### Key Icons

| Feature | Icon |
|---------|------|
| Home | `home` |
| Trips | `route` |
| History | `history` |
| Settings | `settings` |
| Create alarm | `add_location_alt` |
| Active alarm | `notifications_active` |
| Search | `search` |
| Map | `map` |
| GPS lost | `gps_off` |
| Battery low | `battery_alert` |
| Voice | `record_voice_over` |
| Vibration | `vibration` |
| Flashlight | `flashlight_on` |

All interactive icons must have semantic labels for TalkBack.

---

## Elevation

Material 3 uses tonal surfaces; use elevation sparingly.

| Level | dp | Use |
|-------|-----|-----|
| 0 | 0 | Flat lists, screen background |
| 1 | 1 | Cards, bottom sheets (resting) |
| 2 | 3 | FAB (resting), sticky headers |
| 3 | 6 | FAB (pressed), dialogs |
| 4 | 8 | Navigation drawer |
| 5 | 12 | Modal bottom sheet (peak) |

---

## Corner Radius

| Token | Value | Use |
|-------|-------|-----|
| `radiusXs` | 4 dp | Small badges |
| `radiusSm` | 8 dp | Chips, text fields |
| `radiusMd` | **12 dp** | Buttons, cards (default) |
| `radiusLg` | **16 dp** | Large cards, map overlays |
| `radiusXl` | **20 dp** | Bottom sheets (top corners) |
| `radiusFull` | **28 dp** | FAB, pill buttons, search bar |

Default card radius: **16 dp**.

---

## Spacing System

Base unit: **4 dp**. Use multiples only.

| Token | Value | Use |
|-------|-------|-----|
| `space1` | 4 | Icon-text gap, tight padding |
| `space2` | 8 | Inline spacing, chip padding |
| `space3` | 12 | List item vertical padding |
| `space4` | **16** | Screen horizontal padding, card padding |
| `space5` | 24 | Section gaps |
| `space6` | **32** | Large section gaps |
| `space7` | 48 | Empty state vertical padding |

### Screen Layout

* Horizontal screen padding: **16 dp**
* Between sections: **24 dp**
* Bottom nav clearance: **80 dp** above FAB if both present
* Minimum touch target: **48 × 48 dp**

---

## Shadows

Prefer surface tint over heavy shadows (Material 3).

| Token | Use |
|-------|-----|
| `shadowNone` | Flat cards on surface |
| `shadowSm` | Elevated cards - subtle |
| `shadowMd` | FAB, floating map controls |
| `shadowLg` | Modals only |

Dark mode: reduce shadow opacity; rely on `surfaceContainer` contrast instead.

---

## Animation Duration

| Token | Duration | Curve | Use |
|-------|----------|-------|-----|
| `durationInstant` | 100 ms | `easeOut` | Toggle, chip select |
| `durationFast` | 200 ms | `easeInOut` | Button press, page fade |
| `durationNormal` | **300 ms** | `easeInOut` | Screen transitions |
| `durationSlow` | 400 ms | `easeInOut` | Bottom sheet, expand |
| `durationEmphasis` | 500 ms | `easeOutBack` | Success confirmation |

### Motion Guidelines

* **Tracking mode:** subtle, calm - no bouncing animations on distance updates
* **Alarm ring:** urgent - pulsing scale 1.0 → 1.05 on icon, 800 ms loop
* **Navigation:** shared axis horizontal for sibling screens; fade through for tabs
* **Reduce motion:** respect `MediaQuery.disableAnimations` - instant state changes
* **Distance counter:** animate number changes over 150 ms, not instant jump

---

## Material 3 Tokens

Map to Flutter `ThemeData` / `ColorScheme`:

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: accentColor,
    brightness: brightness,
  ),
  textTheme: interTextTheme,
  cardTheme: CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: Size(48, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    height: 80,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
);
```

Support **Dynamic Color** on Android 12+ via `dynamic_color` package.

---

## Component Library

Reusable components in `lib/shared/widgets/`:

| Component | Description |
|-----------|-------------|
| `NomadScaffold` | Standard scaffold with padding, app bar, bottom nav slot |
| `NomadCard` | Surface card with 16 dp radius, optional tap |
| `NomadPrimaryButton` | Filled button, 48 dp min height |
| `NomadSecondaryButton` | Outlined button |
| `NomadSearchBar` | Rounded search field with leading icon |
| `NomadDistanceDisplay` | Large formatted distance with unit |
| `NomadEtaChip` | ETA badge with icon |
| `NomadStatusBanner` | GPS lost / battery / offline warnings |
| `NomadEmptyState` | Illustration + title + CTA |
| `NomadListTile` | Standard list row with 48 dp touch target |
| `NomadPermissionStep` | Onboarding permission card |
| `NomadAlarmRingActions` | Dismiss / Snooze button row |
| `NomadFavoriteChip` | Horizontal scroll favorite pill |
| `NomadLoadingSkeleton` | Shimmer placeholder |

### Component States

Every interactive component supports:
* Default
* Hover / Focus (where applicable)
* Pressed
* Disabled
* Loading
* Error

---

## Tracking vs Ringing Visual Modes

| Aspect | Tracking (Active Alarm) | Ringing (Alarm Trigger) |
|--------|-------------------------|-------------------------|
| Background | Normal theme | Red urgent theme |
| Primary info | Distance + ETA | "Wake up" + destination |
| Animation | Subtle distance tick | Pulsing alert |
| Actions | Pause, Cancel | Dismiss, Snooze |
| Notification | Low priority ongoing | Max priority full screen |

---

## Related Docs

* [Screens](SCREENS.md)
* [User Flows](USER_FLOWS.md)
* [Assets](ASSETS.md)
* [Widgets](WIDGETS.md)
