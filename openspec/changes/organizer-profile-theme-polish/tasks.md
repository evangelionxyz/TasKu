## 1. Theme System Implementation

- [x] 1.1 Add shared_preferences and flutter_native_splash to pubspec.yaml
- [x] 1.2 Implement ThemeService class in lib/services/theme_service.dart with Dark/Light AppPalette color definitions and shared_preferences persistence
- [x] 1.3 Update main.dart to initialize and provide ThemeService via MultiProvider, and configure MaterialApp theme using the dynamic palette
- [x] 1.4 Migrate globals.dart and navbar/bottom_nav.dart to be theme-aware
- [x] 1.5 Migrate all other UI screens and widgets to consume dynamic colors from ThemeService

## 2. Profile Screen Rebuild

- [x] 2.1 Rebuild profile_screen.dart with settings-style layout, displaying avatar and dynamic user details
- [x] 2.2 Implement editable display name using a bottom sheet and Firebase Auth's updateDisplayName
- [x] 2.3 Add theme toggle switch connected to ThemeService
- [x] 2.4 Implement Help Center info sheet
- [x] 2.5 Implement Delete Account flow with confirmation dialog and recent login re-authentication handling
- [x] 2.6 Add full-width sign-out row and remove the sign-out IconButton from the profile AppBar

## 3. Organizer Tabs, Compartment Map, and Stats

- [x] 3.1 Update organizer_screen.dart to use DefaultTabController with three tabs: Checklist, Compartment, and Stats
- [x] 3.2 Move existing checklist implementation to the Checklist tab view
- [x] 3.3 Create Compartment Map widget featuring a bag placeholder image and filled/empty indicator chips
- [x] 3.4 Create Stats widget displaying AVG Weight (2.4 kg) and AVG Bag Opens (4.2x/day) placeholder cards

## 4. Unchecked-Item Reminder

- [x] 4.1 Implement reminder logic watching BagService.isLocked and checklist unchecked items
- [x] 4.2 Display dismissible/non-dismissible warning on the Dashboard when bag is locked and items are unchecked

## 5. Splash Screen and Android Configuration

- [x] 5.1 Add Bluetooth and Location permission declarations in android/app/src/main/AndroidManifest.xml
- [x] 5.2 Configure and run flutter_native_splash using the assets/logo.png image to generate the launch screens

## 6. Animations and Polish

- [x] 6.1 Add staggered enter animations for Dashboard cards using AnimationController
- [x] 6.2 Add staggered slide/fade animations for checklist list items on the Organizer page
- [x] 6.3 Ensure smooth slide-up animations for bottom sheets and scale for FAB buttons
