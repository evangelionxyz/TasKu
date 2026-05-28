## ADDED Requirements

### Requirement: Display bag lock state
The Dashboard SHALL display whether the bag is locked or unlocked sourced from `BagService.isLocked` (bool). The label SHALL read "Locked" or "Unlocked" and use a padlock icon variant accordingly.

#### Scenario: Bag is locked
- **WHEN** `BagService.isLocked` emits `true`
- **THEN** the security card shows a closed padlock icon with the label "Locked"

#### Scenario: Bag is unlocked
- **WHEN** `BagService.isLocked` emits `false`
- **THEN** the security card shows an open padlock icon with the label "Unlocked" in a warning colour

### Requirement: Display sudden motion alert on Dashboard
The Dashboard front page SHALL display a motion alert indicator sourced from `BagService.motionDetected` (bool). When `true`, the indicator SHALL be visually prominent (e.g., pulsing icon or highlighted badge).

#### Scenario: No motion detected
- **WHEN** `BagService.motionDetected` emits `false`
- **THEN** the security card shows a calm motion icon with label "No motion"

#### Scenario: Sudden motion detected
- **WHEN** `BagService.motionDetected` emits `true`
- **THEN** the security card shows an alert-state animated icon with label "Motion detected!" in a warning/red accent colour
