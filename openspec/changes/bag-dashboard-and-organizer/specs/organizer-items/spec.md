## ADDED Requirements

### Requirement: View packing list
The Organizer screen SHALL display all items in the `users/{uid}/items` Firestore subcollection as a scrollable list. Each item SHALL show its name and a checkbox reflecting the `isPacked` field.

#### Scenario: List with items
- **WHEN** the current user has one or more items in Firestore
- **THEN** the Organizer screen lists each item with its name and packed checkbox

#### Scenario: Empty list
- **WHEN** the current user has no items in Firestore
- **THEN** the Organizer screen shows an empty-state message prompting the user to add items

### Requirement: Add item to packing list
The Organizer screen SHALL provide an action (e.g., FAB or bottom sheet) to add a new item. The item name SHALL be required (non-empty). On confirmation, `OrganizerService.addItem(name)` SHALL write a new document to Firestore.

#### Scenario: Add valid item
- **WHEN** the user submits a non-empty item name
- **THEN** `OrganizerService.addItem(name)` is called and the new item appears in the list immediately via Firestore real-time listener

#### Scenario: Add empty name blocked
- **WHEN** the user attempts to submit an empty item name
- **THEN** the form shows a validation error and does not write to Firestore

### Requirement: Toggle item packed state
The Organizer screen SHALL allow toggling the `isPacked` field on each item by tapping its checkbox. `OrganizerService.togglePacked(itemId, currentState)` SHALL update Firestore.

#### Scenario: Mark item as packed
- **WHEN** the user taps the unchecked checkbox on an item
- **THEN** `OrganizerService.togglePacked(itemId, false)` is called and the checkbox becomes checked with a visual strikethrough on the item name

#### Scenario: Unmark item as packed
- **WHEN** the user taps the checked checkbox on an item
- **THEN** `OrganizerService.togglePacked(itemId, true)` is called and the checkbox becomes unchecked

### Requirement: Delete item from packing list
The Organizer screen SHALL allow deleting an item via a swipe-to-dismiss gesture or a delete action. `OrganizerService.deleteItem(itemId)` SHALL remove the Firestore document.

#### Scenario: Delete via swipe
- **WHEN** the user swipes an item left or right to dismiss
- **THEN** `OrganizerService.deleteItem(itemId)` is called and the item is removed from the list

### Requirement: Force re-fetch organizer list
`OrganizerService` SHALL expose a `refresh()` method that cancels the existing Firestore listener and creates a new one, effectively re-fetching all items.

#### Scenario: Cloud sync tap triggers refresh
- **WHEN** `OrganizerService.refresh()` is called (e.g., from the Dashboard cloud sync tap)
- **THEN** the Firestore listener is re-established and the item list is updated with the latest data
