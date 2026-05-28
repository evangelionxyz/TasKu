## ADDED Requirements

### Requirement: Compartment Map placeholder tab
The Organizer screen SHALL include a "Compartment" tab displaying a placeholder bag silhouette image and a row of compartment indicator chips (e.g., Main, Side, Front). Each chip SHALL show "Filled" or "Empty" with a colored indicator. The data SHALL be hardcoded as a placeholder.

#### Scenario: Compartment map tab visible
- **WHEN** the user taps the "Compartment" tab in the Organizer
- **THEN** a bag image placeholder and compartment indicator chips are rendered

#### Scenario: Filled compartment shown
- **WHEN** a compartment is marked as filled (hardcoded)
- **THEN** its chip shows a filled/colored indicator and label "Filled"

#### Scenario: Empty compartment shown
- **WHEN** a compartment is marked as empty (hardcoded)
- **THEN** its chip shows a dimmed indicator and label "Empty"

### Requirement: Statistics placeholder tab
The Organizer screen SHALL include a "Stats" tab displaying two placeholder statistic cards: "AVG Weight" and "AVG Bag Opens". Values SHALL be hardcoded mock data (e.g., "2.4 kg" and "4.2×/day").

#### Scenario: Stats tab shows placeholder values
- **WHEN** the user taps the "Stats" tab
- **THEN** two stat cards are visible with mock AVG Weight and AVG Bag Opens values
