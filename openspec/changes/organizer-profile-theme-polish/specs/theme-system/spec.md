## ADDED Requirements

### Requirement: ThemeService holds isDark state and exposes AppPalette
`ThemeService` SHALL be a `ChangeNotifier` that holds `isDark` (bool, default `true`) and exposes a `colors` getter returning the appropriate `AppPalette` instance. `ThemeService` SHALL persist `isDark` to `SharedPreferences` on every toggle and restore it on initialization.

#### Scenario: Default to dark mode
- **WHEN** the app launches for the first time (no stored preference)
- **THEN** `ThemeService.isDark` is `true` and dark palette colors are used throughout the UI

#### Scenario: Persist theme across restarts
- **WHEN** the user toggles to light mode and restarts the app
- **THEN** `ThemeService.isDark` is `false` (restored from SharedPreferences) and light palette colors are used

#### Scenario: Toggle theme
- **WHEN** `ThemeService.toggleTheme()` is called
- **THEN** `isDark` flips, `colors` returns the new palette, and all listening widgets rebuild

### Requirement: AppPalette defines semantic color roles
`AppPalette` SHALL be an immutable value class with the following fields: `bg`, `surface`, `card`, `onCard`, `accent`, `accentDim`, `danger`, `onDanger`. Two pre-built instances SHALL exist: `AppPalette.dark` and `AppPalette.light`.

#### Scenario: Dark palette colors applied
- **WHEN** `isDark == true`
- **THEN** `ThemeService.colors.bg` returns `#121210`, `surface` returns `#1E2015`, `card` returns `#2A2C21`

#### Scenario: Light palette colors applied
- **WHEN** `isDark == false`
- **THEN** `ThemeService.colors.bg` returns `#F5F2ED`, `surface` returns `#E5DDD2`, `card` returns `#E5DDD2`

### Requirement: All app widgets use ThemeService.colors
Every widget that previously referenced `AppColors.*` SHALL be updated to read colors from `context.watch<ThemeService>().colors.*` (or `context.read` where rebuild is not needed). The `MaterialApp` background color SHALL also update based on the theme.

#### Scenario: Widgets respond to theme toggle
- **WHEN** the user switches theme
- **THEN** all visible cards, backgrounds, text, and icons update their colors within one frame without a hot restart
