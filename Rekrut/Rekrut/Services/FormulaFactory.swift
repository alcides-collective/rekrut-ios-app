//
//  FormulaFactory.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

/// Factory for creating Formula objects for different study programs
struct FormulaFactory {
    
    // MARK: - Standard IT Formula
    static func createITFormula(universityId: String, programId: String) -> Formula {
        Formula(
            version: "2.0",
            universityId: universityId,
            programId: programId,
            type: .simple,
            stages: [
                FormulaStage(
                    id: "main",
                    name: "Rekrutacja standardowa",
                    components: [
                        FormulaComponent(
                            id: "mat",
                            type: ComponentType.maturaExam,
                            subject: "MAT",
                            level: "R",
                            weight: 0.5,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "inf",
                            type: ComponentType.maturaExam,
                            subject: "INF",
                            level: "R",
                            weight: 0.3,
                            levelCoefficients: nil,
                            required: false,
                            alternatives: ["FIZ", "CHEM"],
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "ang",
                            type: ComponentType.maturaExam,
                            subject: "ANG",
                            level: "R",
                            weight: 0.2,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        )
                    ],
                    operations: nil,
                    practicalExams: nil,
                    threshold: nil,
                    coefficient: 1.0,
                    maxPoints: 100
                )
            ],
            bonuses: nil,
            requirements: FormulaRequirements(
                mandatorySubjects: ["MAT", "J.OBC"],
                minimumScores: nil,
                practicalTestRequired: false,
                interviewRequired: false,
                portfolioRequired: false,
                previousDegreeRequired: false
            ),
            metadata: FormulaMetadata(
                description: "0.5 × matematyka (R) + 0.3 × informatyka (R) + 0.2 × język obcy (R)",
                lastYearThreshold: 85.5,
                averageThreshold: 83.0,
                maxPossibleScore: 100,
                scoringUnit: "points",
                officialCalculatorURL: nil,
                notes: nil,
                lastUpdated: Date()
            )
        )
    }
    
    // MARK: - Law Formula
    static func createLawFormula(universityId: String, programId: String) -> Formula {
        Formula(
            version: "2.0",
            universityId: universityId,
            programId: programId,
            type: .simple,
            stages: [
                FormulaStage(
                    id: "main",
                    name: "Rekrutacja standardowa",
                    components: [
                        FormulaComponent(
                            id: "pol",
                            type: ComponentType.maturaExam,
                            subject: "POL",
                            level: "R",
                            weight: 0.4,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "his",
                            type: ComponentType.maturaExam,
                            subject: "HIS",
                            level: "R",
                            weight: 0.3,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "wos",
                            type: ComponentType.maturaExam,
                            subject: "WOS",
                            level: "R",
                            weight: 0.3,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        )
                    ],
                    operations: nil,
                    practicalExams: nil,
                    threshold: nil,
                    coefficient: 1.0,
                    maxPoints: 100
                )
            ],
            bonuses: nil,
            requirements: FormulaRequirements(
                mandatorySubjects: ["POL"],
                minimumScores: nil,
                practicalTestRequired: false,
                interviewRequired: false,
                portfolioRequired: false,
                previousDegreeRequired: false
            ),
            metadata: FormulaMetadata(
                description: "0.4 × język polski (R) + 0.3 × historia (R) + 0.3 × WOS (R)",
                lastYearThreshold: 92.0,
                averageThreshold: 90.0,
                maxPossibleScore: 100,
                scoringUnit: "points",
                officialCalculatorURL: nil,
                notes: nil,
                lastUpdated: Date()
            )
        )
    }
    
    // MARK: - Medicine Formula
    static func createMedicineFormula(universityId: String, programId: String) -> Formula {
        Formula(
            version: "2.0",
            universityId: universityId,
            programId: programId,
            type: .simple,
            stages: [
                FormulaStage(
                    id: "main",
                    name: "Rekrutacja standardowa",
                    components: [
                        FormulaComponent(
                            id: "bio",
                            type: ComponentType.maturaExam,
                            subject: "BIO",
                            level: "R",
                            weight: 0.4,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "chem",
                            type: ComponentType.maturaExam,
                            subject: "CHEM",
                            level: "R",
                            weight: 0.4,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "mat",
                            type: ComponentType.maturaExam,
                            subject: "MAT",
                            level: "R",
                            weight: 0.2,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: ["FIZ"],
                            minScore: nil,
                            maxScore: 100
                        )
                    ],
                    operations: nil,
                    practicalExams: nil,
                    threshold: nil,
                    coefficient: 1.0,
                    maxPoints: 100
                )
            ],
            bonuses: nil,
            requirements: FormulaRequirements(
                mandatorySubjects: ["BIO", "CHEM"],
                minimumScores: ["BIO": 30, "CHEM": 30],
                practicalTestRequired: false,
                interviewRequired: false,
                portfolioRequired: false,
                previousDegreeRequired: false
            ),
            metadata: FormulaMetadata(
                description: "0.4 × biologia (R) + 0.4 × chemia (R) + 0.2 × matematyka (R)",
                lastYearThreshold: 95.0,
                averageThreshold: 93.0,
                maxPossibleScore: 100,
                scoringUnit: "points",
                officialCalculatorURL: nil,
                notes: nil,
                lastUpdated: Date()
            )
        )
    }
    
    // MARK: - Architecture Formula (Complex)
    static func createArchitectureFormula(universityId: String, programId: String) -> Formula {
        Formula(
            version: "2.0",
            universityId: universityId,
            programId: programId,
            type: .mixed,
            stages: [
                FormulaStage(
                    id: "main",
                    name: "Rekrutacja z egzaminem praktycznym",
                    components: [
                        FormulaComponent(
                            id: "drawing_test",
                            type: ComponentType.practicalExam,
                            subject: nil,
                            level: nil,
                            weight: 0.5,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: 30, // 30% minimum
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "mat",
                            type: ComponentType.maturaExam,
                            subject: "MAT",
                            level: "R",
                            weight: 0.3,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "additional",
                            type: ComponentType.maturaExam,
                            subject: "ADDITIONAL",
                            level: "R",
                            weight: 0.2,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: ["FIZ", "INF", "GEO", "HIS"],
                            minScore: nil,
                            maxScore: 100
                        )
                    ],
                    operations: [
                        Operation(
                            id: "op1",
                            type: .max,
                            componentIds: ["additional_fiz", "additional_inf", "additional_geo", "additional_his"],
                            value: nil,
                            resultId: "additional_result"
                        )
                    ],
                    practicalExams: [
                        PracticalExam(
                            id: "drawing_test",
                            name: "Egzamin z rysunku",
                            type: .drawing,
                            weight: 1.0,
                            tasks: [
                                ExamTask(name: "Rysunek odręczny", points: 50, duration: 120),
                                ExamTask(name: "Kompozycja przestrzenna", points: 50, duration: 120)
                            ],
                            minScore: 30,
                            maxPoints: 100,
                            description: "Sprawdzenie predyspozycji plastycznych i wyobraźni przestrzennej"
                        )
                    ],
                    threshold: Threshold(
                        type: .minimum,
                        value: 30,
                        description: "Minimum 30% z egzaminu praktycznego"
                    ),
                    coefficient: 1.0,
                    maxPoints: 100
                )
            ],
            bonuses: nil,
            requirements: FormulaRequirements(
                mandatorySubjects: ["MAT"],
                minimumScores: nil,
                practicalTestRequired: true,
                interviewRequired: false,
                portfolioRequired: false,
                previousDegreeRequired: false
            ),
            metadata: FormulaMetadata(
                description: "0.4 × matematyka (R) + 0.3 × max(fizyka, informatyka, geografia, historia) (R) + 0.3 × egzamin z rysunku",
                lastYearThreshold: 75.0,
                averageThreshold: 72.0,
                maxPossibleScore: 100,
                scoringUnit: "points",
                officialCalculatorURL: nil,
                notes: "Wymagany egzamin z rysunku",
                lastUpdated: Date()
            )
        )
    }
    
    // MARK: - Psychology Formula
    static func createPsychologyFormula(universityId: String, programId: String) -> Formula {
        Formula(
            version: "2.0",
            universityId: universityId,
            programId: programId,
            type: .simple,
            stages: [
                FormulaStage(
                    id: "main",
                    name: "Rekrutacja standardowa",
                    components: [
                        FormulaComponent(
                            id: "bio",
                            type: ComponentType.maturaExam,
                            subject: "BIO",
                            level: "R",
                            weight: 0.5,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "additional",
                            type: ComponentType.maturaExam,
                            subject: "ADDITIONAL",
                            level: "R",
                            weight: 0.3,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: ["MAT", "POL", "HIS", "WOS"],
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "pol",
                            type: ComponentType.maturaExam,
                            subject: "POL",
                            level: "P",
                            weight: 0.2,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        )
                    ],
                    operations: [
                        Operation(
                            id: "op1",
                            type: .max,
                            componentIds: ["additional_mat", "additional_pol", "additional_his", "additional_wos"],
                            value: nil,
                            resultId: "additional_result"
                        )
                    ],
                    practicalExams: nil,
                    threshold: nil,
                    coefficient: 1.0,
                    maxPoints: 100
                )
            ],
            bonuses: nil,
            requirements: FormulaRequirements(
                mandatorySubjects: ["BIO", "POL"],
                minimumScores: nil,
                practicalTestRequired: false,
                interviewRequired: false,
                portfolioRequired: false,
                previousDegreeRequired: false
            ),
            metadata: FormulaMetadata(
                description: "0.5 × biologia (R) + 0.3 × max(matematyka, język polski, historia, WOS) (R) + 0.2 × język polski (P)",
                lastYearThreshold: 88.0,
                averageThreshold: 85.0,
                maxPossibleScore: 100,
                scoringUnit: "points",
                officialCalculatorURL: nil,
                notes: nil,
                lastUpdated: Date()
            )
        )
    }
    
    // MARK: - Simple weighted formula generator
    static func createSimpleFormula(
        universityId: String,
        programId: String,
        components: [(subject: String, level: String, weight: Double)],
        mandatorySubjects: [String] = [],
        lastYearThreshold: Double? = nil
    ) -> Formula {
        let formulaComponents = components.enumerated().map { index, component in
            FormulaComponent(
                id: "c\(index + 1)",
                type: ComponentType.maturaExam,
                subject: component.subject,
                level: component.level,
                weight: component.weight,
                levelCoefficients: nil,
                required: mandatorySubjects.contains(component.subject),
                alternatives: nil,
                minScore: nil,
                maxScore: 100
            )
        }
        
        return Formula(
            version: "2.0",
            universityId: universityId,
            programId: programId,
            type: .simple,
            stages: [
                FormulaStage(
                    id: "main",
                    name: "Rekrutacja standardowa",
                    components: formulaComponents,
                    operations: nil,
                    practicalExams: nil,
                    threshold: nil,
                    coefficient: 1.0,
                    maxPoints: 100
                )
            ],
            bonuses: nil,
            requirements: FormulaRequirements(
                mandatorySubjects: mandatorySubjects.isEmpty ? nil : mandatorySubjects,
                minimumScores: nil,
                practicalTestRequired: false,
                interviewRequired: false,
                portfolioRequired: false,
                previousDegreeRequired: false
            ),
            metadata: FormulaMetadata(
                description: generateFormulaDescription(from: components),
                lastYearThreshold: lastYearThreshold,
                averageThreshold: nil,
                maxPossibleScore: 100,
                scoringUnit: "points",
                officialCalculatorURL: nil,
                notes: nil,
                lastUpdated: Date()
            )
        )
    }
    
    // MARK: - Helper Methods
    
    private static func generateFormulaDescription(from components: [(subject: String, level: String, weight: Double)]) -> String {
        components.map { component in
            let subjectName = getSubjectName(component.subject)
            let levelText = component.level == "R" ? " (R)" : " (P)"
            if component.weight == 1.0 {
                return "\(subjectName)\(levelText)"
            } else {
                let weightText = component.weight == floor(component.weight) ? 
                    String(format: "%.0f", component.weight) : 
                    String(format: "%.1f", component.weight)
                return "\(weightText) × \(subjectName)\(levelText)"
            }
        }.joined(separator: " + ")
    }
    
    private static func getSubjectName(_ code: String) -> String {
        let subjectMap: [String: String] = [
            "MAT": "matematyka",
            "POL": "język polski",
            "FIZ": "fizyka",
            "CHEM": "chemia",
            "BIO": "biologia",
            "INF": "informatyka",
            "HIS": "historia",
            "GEO": "geografia",
            "WOS": "WOS",
            "J.OBC": "język obcy",
            "ANG": "język angielski",
            "NIEM": "język niemiecki",
            "FRA": "język francuski",
            "HISZ": "język hiszpański",
            "FIL": "filozofia",
            "FILO": "filozofia"
        ]
        return subjectMap[code] ?? code.lowercased()
    }
}