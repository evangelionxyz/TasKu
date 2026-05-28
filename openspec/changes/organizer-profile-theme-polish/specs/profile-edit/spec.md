## ADDED Requirements

### Requirement: Profile edit — update display name
The Profile screen SHALL allow the signed-in user to tap an edit button next to their display name, enter a new name in a bottom sheet, and save it via `FirebaseAuth.instance.currentUser?.updateDisplayName(name)`.

#### Scenario: Edit display name
- **WHEN** the user taps the edit icon next to their display name
- **THEN** a bottom sheet opens with a pre-filled text field and a confirm button

#### Scenario: Save display name
- **WHEN** the user submits a non-empty new display name
- **THEN** `updateDisplayName` is called and the displayed name updates

#### Scenario: Cancel edit
- **WHEN** the user dismisses the bottom sheet without submitting
- **THEN** the display name remains unchanged

### Requirement: Profile sign-out row
The Profile screen SHALL display a sign-out action as a full-width tappable row at the bottom of the settings list. The AppBar SHALL NOT contain a sign-out button.

#### Scenario: Sign out via settings row
- **WHEN** the user taps the "Sign Out" row on the Profile screen
- **THEN** `FirebaseAuth.instance.signOut()` is called and the user is returned to the auth screen

### Requirement: Help center sheet
The Profile screen SHALL include a "Help Center" row that, when tapped, opens a modal bottom sheet with placeholder help content (FAQ stub or placeholder text).

#### Scenario: Help center opens
- **WHEN** the user taps "Help Center"
- **THEN** a bottom sheet slides up with help/FAQ placeholder content

### Requirement: Delete account flow
The Profile screen SHALL include a "Delete Account" row. Tapping it SHALL show a confirmation dialog. If confirmed, `FirebaseAuth.instance.currentUser?.delete()` SHALL be called. If re-authentication is required, the user SHALL be informed with an error message.

#### Scenario: Delete account with confirmation
- **WHEN** the user taps "Delete Account" and confirms the dialog
- **THEN** the account is deleted and the user is returned to the auth screen

#### Scenario: Delete account cancelled
- **WHEN** the user taps "Cancel" on the confirmation dialog
- **THEN** nothing happens and the Profile screen remains

#### Scenario: Re-auth required
- **WHEN** `delete()` throws `requires-recent-login`
- **THEN** an error snackbar informs the user to sign out and sign in again before deleting
