# Rekrut Formula Specification v2.0 - Advanced Polish University Admissions

## Overview

Version 2.0 extends the formula format to support the most complex Polish university admission systems, including:
- Multi-stage recruitment (e.g., MISH Warsaw)
- Practical exams with minimum thresholds (e.g., Architecture)
- Level-based coefficients (0.4/1.0/1.3 for basic/extended/bilingual)
- Olympic bonuses up to 200 points
- Mixed formulas combining exams, portfolios, and interviews
- International exam conversions (IB/EB)

## JSON Schema v2.0

```json
{
  "version": "2.0",
  "university_id": "string",
  "program_id": "string",
  "type": "simple|multi_stage|conditional|mixed",
  "stages": [
    {
      "id": "string",
      "name": "string",
      "components": [...],
      "operations": [...],
      "practical_exams": [...],
      "threshold": {...},
      "coefficient": "number",
      "max_points": "number"
    }
  ],
  "bonuses": [...],
  "requirements": {...},
  "metadata": {...}
}
```

## New Features in v2.0

### 1. Multi-Stage Support

```json
"stages": [
  {
    "id": "stage1",
    "name": "Etap I - Punkty maturalne",
    "components": [...],
    "threshold": {
      "type": "minimum",
      "value": 60,
      "description": "Minimum 60 points to advance"
    },
    "coefficient": 0.7,
    "max_points": 100
  },
  {
    "id": "stage2",
    "name": "Etap II - Rozmowa kwalifikacyjna",
    "components": [...],
    "coefficient": 0.3,
    "max_points": 100
  }
]
```

### 2. Level Coefficients

Support for different multipliers based on exam level:

```json
"level_coefficients": {
  "basic": 0.4,      // Poziom podstawowy
  "extended": 1.0,   // Poziom rozszerzony
  "bilingual": 1.3,  // Matura dwujęzyczna
  "international": 1.0 // For IB/EB conversions
}
```

### 3. Practical Exams

```json
"practical_exams": [
  {
    "id": "drawing_test",
    "name": "Test sprawności plastycznej",
    "type": "drawing",
    "weight": 1.0,
    "tasks": [
      {
        "name": "Zadanie graficzne 1",
        "points": 100,
        "duration": 120
      }
    ],
    "min_score": 60,
    "max_points": 200,
    "description": "Two graphic tasks testing spatial imagination"
  }
]
```

### 4. Component Types

Extended component types:
- `matura_exam` - Standard Matura exam
- `practical_exam` - Drawing, sculpture, physical tests
- `interview` - Qualification interview
- `portfolio` - Portfolio assessment
- `previous_degree` - GPA from previous studies
- `olympiad` - Olympiad achievements
- `certificate` - Language/skill certificates

### 5. Bonus System

```json
"bonuses": [
  {
    "id": "olympiad_bonus",
    "type": "olympiad",
    "condition": "Central olympiad winner",
    "points": 200,
    "max_bonus": 200
  }
]
```

### 6. Requirements

```json
"requirements": {
  "mandatory_subjects": ["MAT", "J.OBC"],
  "minimum_scores": {
    "MAT": 30
  },
  "practical_test_required": true,
  "interview_required": false,
  "portfolio_required": false,
  "previous_degree_required": false
}
```

## Real-World Examples

### Example 1: Warsaw Tech Architecture (Most Complex)

```json
{
  "version": "2.0",
  "university_id": "pw",
  "program_id": "pw-architektura",
  "type": "mixed",
  "stages": [
    {
      "id": "main",
      "name": "Rekrutacja główna",
      "components": [
        {
          "id": "psp",
          "type": "practical_exam",
          "weight": 1.0,
          "required": true,
          "min_score": 60,
          "max_score": 200
        },
        {
          "id": "mat",
          "type": "matura_exam",
          "subject": "MAT",
          "level": "R",
          "weight": 0.75,
          "required": true
        },
        {
          "id": "jo",
          "type": "matura_exam",
          "subject": "J.OBC",
          "level": "R",
          "weight": 0.25,
          "required": true
        },
        {
          "id": "wyb1",
          "type": "matura_exam",
          "subject": "GROUP1",
          "level": "R",
          "weight": 0.5,
          "required": true,
          "alternatives": ["FIZ", "INF", "GEO"]
        },
        {
          "id": "wyb2",
          "type": "matura_exam",
          "subject": "GROUP2",
          "level": "R",
          "weight": 0.5,
          "required": true,
          "alternatives": ["HIS", "WOS", "FIL"]
        }
      ],
      "practical_exams": [
        {
          "id": "psp",
          "name": "Test sprawności plastycznej",
          "type": "drawing",
          "weight": 1.0,
          "tasks": [
            {"name": "Zadanie graficzne 1", "points": 100, "duration": 120},
            {"name": "Zadanie graficzne 2", "points": 100, "duration": 120}
          ],
          "min_score": 60,
          "max_points": 200
        }
      ],
      "threshold": {
        "type": "minimum",
        "value": 60,
        "description": "Minimum 30% z testu praktycznego"
      },
      "max_points": 400
    }
  ],
  "metadata": {
    "description": "Architektura - Politechnika Warszawska",
    "last_year_threshold": 325.5,
    "max_possible_score": 400,
    "scoring_unit": "points"
  }
}
```

### Example 2: MISH Warsaw (Two-Stage)

```json
{
  "version": "2.0",
  "university_id": "uw",
  "program_id": "uw-mish",
  "type": "multi_stage",
  "stages": [
    {
      "id": "stage1",
      "name": "Etap I - Ocena świadectw",
      "components": [...],
      "threshold": {
        "type": "minimum",
        "value": 60
      },
      "coefficient": 0.6,
      "max_points": 100
    },
    {
      "id": "stage2",
      "name": "Etap II - Rozmowa kwalifikacyjna",
      "components": [
        {
          "id": "interview",
          "type": "interview",
          "weight": 1.0,
          "required": true,
          "max_score": 100
        }
      ],
      "coefficient": 0.4,
      "max_points": 100
    }
  ],
  "requirements": {
    "mandatory_subjects": ["MAT", "POL", "J.OBC"],
    "interview_required": true
  },
  "metadata": {
    "description": "MISH - Międzywydziałowe Indywidualne Studia Humanistyczne",
    "notes": "Only 2x number of places advance to interview",
    "max_possible_score": 100,
    "scoring_unit": "points"
  }
}
```

### Example 3: Medical University (600 points)

```json
{
  "version": "2.0",
  "university_id": "umed-lodz",
  "program_id": "medicine",
  "type": "simple",
  "stages": [
    {
      "id": "main",
      "name": "Standard recruitment",
      "components": [
        {
          "id": "bio",
          "type": "matura_exam",
          "subject": "BIO",
          "level": "R",
          "weight": 2.0,
          "required": true,
          "max_score": 100
        },
        {
          "id": "chem",
          "type": "matura_exam",
          "subject": "CHEM",
          "level": "R",
          "weight": 2.0,
          "required": true,
          "max_score": 100
        },
        {
          "id": "third",
          "type": "matura_exam",
          "subject": "THIRD",
          "level": "R",
          "weight": 2.0,
          "required": true,
          "alternatives": ["MAT", "FIZ"],
          "max_score": 100
        }
      ],
      "operations": [
        {
          "type": "max",
          "component_ids": ["third_mat", "third_fiz"],
          "result_id": "third_result"
        }
      ],
      "max_points": 600
    }
  ],
  "metadata": {
    "description": "Kierunek lekarski - Uniwersytet Medyczny w Łodzi",
    "last_year_threshold": 540,
    "max_possible_score": 600,
    "scoring_unit": "points",
    "notes": "Highest point threshold in Poland"
  }
}
```

## Implementation Guidelines

### Swift Implementation

```swift
// Parse from JSON
let formula = try JSONDecoder().decode(FormulaV2.self, from: jsonData)

// Calculate with extended scores
let scores = AdvancedFormulaCalculator.ExtendedScores(
    maturaScores: maturaScores,
    practicalExams: ["psp": 140],
    isBilingual: false,
    examSystem: .polish
)

let result = AdvancedFormulaCalculator.calculate(formula: formula, scores: scores)
print("Total: \(result.totalScore) / \(formula.metadata.maxPossibleScore)")
```

### Python Implementation

```python
# Parse formula
calculator = AdvancedFormulaCalculator()
formula = calculator.parse_formula_json(json_str)

# Prepare scores
scores = ExtendedScores(
    matura_scores=MaturaScores(
        mathematics=85,
        biology=90,
        chemistry=88
    ),
    practical_exams={"drawing_test": 140},
    is_bilingual=False
)

# Calculate
result = calculator.calculate(formula, scores)
print(f"Total: {result.total_score} / {formula.metadata.max_possible_score}")
```

## Conversion Support

### International Baccalaureate (IB)
```python
ib_score = 6  # IB grade (1-7)
polish_equivalent = (ib_score * 100) / 7  # = 85.7
```

### European Baccalaureate (EB)
```python
eb_score = 8.5  # EB grade (1-10)
polish_equivalent = eb_score * 10  # = 85
```

## Benefits of v2.0

1. **Complete Coverage**: Handles all Polish university formulas
2. **Multi-stage Support**: Complex recruitment processes
3. **Flexible Coefficients**: Bilingual bonus, level multipliers
4. **Practical Exams**: Drawing, physical, musical tests
5. **Bonus System**: Olympics, certificates, volunteering
6. **International**: IB/EB conversion support
7. **Validation**: Requirements and threshold checking
8. **Future-proof**: Extensible for new admission types