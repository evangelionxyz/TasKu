## ADDED Requirements

### Requirement: Show reminder when bag is locked with unchecked items
The Dashboard SHALL display a dismissible reminder banner/snackbar when `BagService.isLocked == true` AND `OrganizerService.items` contains at least one item where `isPacked == false`.

#### Scenario: Reminder shown when locked with unchecked items
- **WHEN** the bag is locked and one or more items are not packed
- **THEN** a visible reminder message appears on the Dashboard (e.g., "You have unpacked items! Check your organizer.")

#### Scenario: Reminder hidden when all items are packed
- **WHEN** all items have `isPacked == true`
- **THEN** no reminder is shown

#### Scenario: Reminder hidden when bag is unlocked
- **WHEN** `BagService.isLocked == false`
- **THEN** no reminder is shown regardless of item states
