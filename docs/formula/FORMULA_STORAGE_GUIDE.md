# Formula Storage Guide - Rekrut v2.0

## Overview

In Rekrut v2.0, admission formulas are stored as structured JSON objects instead of string expressions. This provides type safety, better validation, and cross-platform compatibility between iOS and backend systems.

## Storage Architecture

### 1. Database Structure

Formulas can be stored in two ways:

#### Option A: Embedded in Program Documents
```json
{
  "programId": "uw-informatyka",
  "universityId": "uw",
  "requirements": {
    "formula": {
      "version": "2.0",
      "type": "simple",
      "stages": [...],
      "metadata": {...}
    },
    "formulaId": "uw-informatyka-formula-v1"
  }
}
```

#### Option B: Separate Formula Collection
```json
// formulas/{formulaId}
{
  "id": "uw-informatyka-formula-v1",
  "version": "2.0",
  "universityId": "uw",
  "programIds": ["uw-informatyka", "uw-informatyka-eng"],
  "type": "simple",
  "stages": [...],
  "metadata": {
    "lastUpdated": "2025-01-01",
    "approvedBy": "admission-office",
    "validFrom": "2025-09-01",
    "validUntil": "2026-08-31"
  }
}
```

### 2. Formula Model Structure

```swift
struct Formula: Codable {
    let version: String           // "2.0"
    let universityId: String      // "uw"
    let programId: String         // "uw-informatyka"
    let type: FormulaType         // .simple, .multiStage, .mixed
    let stages: [FormulaStage]    // Calculation stages
    let bonuses: [BonusRule]?     // Optional bonus points
    let requirements: FormulaRequirements?  // Entry requirements
    let metadata: FormulaMetadata // Description, thresholds, etc.
}
```

## Storage Patterns

### 1. Simple Weighted Formula
Most common pattern for programs using only Matura exam scores:

```json
{
  "version": "2.0",
  "type": "simple",
  "stages": [{
    "id": "main",
    "name": "Rekrutacja standardowa",
    "components": [
      {
        "id": "mat",
        "type": "matura_exam",
        "subject": "MAT",
        "level": "R",
        "weight": 0.5,
        "required": true
      },
      {
        "id": "inf",
        "type": "matura_exam",
        "subject": "INF",
        "level": "R",
        "weight": 0.3,
        "alternatives": ["FIZ", "CHEM"]
      }
    ],
    "maxPoints": 100
  }]
}
```

### 2. Multi-Stage Formula
For programs with interviews or multiple selection stages:

```json
{
  "version": "2.0",
  "type": "multi_stage",
  "stages": [
    {
      "id": "stage1",
      "name": "Etap I - Ocena świadectw",
      "components": [...],
      "threshold": {"type": "minimum", "value": 60},
      "coefficient": 0.6
    },
    {
      "id": "stage2", 
      "name": "Etap II - Rozmowa",
      "components": [
        {"type": "interview", "weight": 1.0}
      ],
      "coefficient": 0.4
    }
  ]
}
```

### 3. Mixed Formula with Practical Exams
For programs requiring additional tests (architecture, arts, sports):

```json
{
  "version": "2.0",
  "type": "mixed",
  "stages": [{
    "components": [
      {
        "type": "practical_exam",
        "weight": 0.5,
        "minScore": 30
      },
      {
        "type": "matura_exam",
        "subject": "MAT",
        "weight": 0.5
      }
    ],
    "practicalExams": [{
      "id": "drawing_test",
      "name": "Test rysunku",
      "tasks": [
        {"name": "Rysunek odręczny", "points": 100}
      ]
    }]
  }]
}
```

## Database Implementation

### Firebase Firestore Structure

```
firestore-root/
├── universities/
│   └── {universityId}/
│       ├── info...
│       └── programs/
│           └── {programId}/
│               ├── basicInfo...
│               └── requirements/
│                   ├── formula: {embedded Formula object}
│                   └── formulaId: "reference-to-formula"
│
└── formulas/  // Optional: Shared formula collection
    └── {formulaId}/
        └── {complete Formula object}
```

### Formula Versioning

Each formula includes version tracking:

```json
{
  "metadata": {
    "lastUpdated": "2025-01-15T10:00:00Z",
    "version": "2.0",
    "changeHistory": [
      {
        "date": "2025-01-15",
        "description": "Updated INF weight from 0.2 to 0.3",
        "approvedBy": "admission-committee"
      }
    ]
  }
}
```

## Usage in Application

### 1. Loading Formula
```swift
// From program requirements
if let formula = program.requirements.formula {
    let result = FormulaCalculator.calculate(
        formula: formula, 
        scores: userScores
    )
}

// From formula reference
if let formulaId = program.requirements.formulaId {
    let formula = await FirebaseService.shared.fetchFormula(id: formulaId)
    // Calculate...
}
```

### 2. Creating Formulas
```swift
// Using FormulaFactory for common patterns
let formula = FormulaFactory.createITFormula(
    universityId: "uw",
    programId: "uw-informatyka"
)

// Custom formula
let formula = FormulaFactory.createSimpleFormula(
    universityId: "uw",
    programId: "uw-biologia",
    components: [
        ("BIO", "R", 0.6),
        ("CHEM", "R", 0.4)
    ],
    mandatorySubjects: ["BIO"]
)
```

## Benefits of Structured Storage

1. **Type Safety**: No parsing errors from malformed strings
2. **Validation**: Can validate formula structure before storage
3. **Flexibility**: Easy to add new component types or operations
4. **Cross-platform**: Same JSON works in iOS, Android, and web
5. **Analytics**: Can query formulas by type, components, etc.
6. **Versioning**: Track formula changes over time
7. **Localization**: Descriptions can be localized separately

## Migration from String Formulas

For existing systems using string formulas:

1. Keep legacy string in metadata for reference
2. Use automated converter during migration
3. Validate converted formulas match original calculations

```json
{
  "metadata": {
    "legacyFormula": "W = 0.5 * MAT_R + 0.3 * INF_R + 0.2 * ANG_R",
    "migrationDate": "2025-01-01",
    "validated": true
  }
}
```

## Best Practices

1. **Store formulaId reference** in program documents for shared formulas
2. **Embed formula directly** only for program-specific formulas
3. **Version all changes** with metadata timestamps
4. **Validate formulas** before storing in production
5. **Cache formulas** locally for offline calculation
6. **Document changes** in metadata for audit trail