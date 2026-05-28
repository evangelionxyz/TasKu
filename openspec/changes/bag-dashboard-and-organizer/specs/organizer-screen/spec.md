## MODIFIED Requirements

### Requirement: Organizer screen shows header and packing list
The Organizer screen (`OrganizerPage`) SHALL display a screen-level header text "Organizer" in the `AppBar`. The screen body SHALL render the packing list powered by `OrganizerService`, a FAB to add items, and swipe-to-dismiss for deletion.

#### Scenario: Organizer header visible
- **WHEN** the user navigates to the Organizer tab
- **THEN** the AppBar displays the "Organizer" header text

#### Scenario: Packing list rendered
- **WHEN** `OrganizerService` has emitted the item list
- **THEN** the Organizer screen renders the list of items with checkboxes and item names
