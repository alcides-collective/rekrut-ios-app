//
//  FormulaView.swift
//  Rekrut
//
//  Created by Assistant on 30/05/2025.
//

import SwiftUI

struct FormulaView: View {
    let formula: String
    @State private var parsedFormula: [FormulaElement] = []
    
    var body: some View {
        // Split formula into parts at + operators for better wrapping
        VStack(alignment: .center, spacing: 4) {
            ForEach(Array(splitIntoLines().enumerated()), id: \.offset) { index, line in
                HStack(spacing: 2) {
                    ForEach(line.indices, id: \.self) { elementIndex in
                        line[elementIndex].view
                    }
                }
            }
        }
        .onAppear {
            parsedFormula = parseFormula(formula)
        }
    }
    
    private func splitIntoLines() -> [[FormulaElement]] {
        var lines: [[FormulaElement]] = []
        var currentLine: [FormulaElement] = []
        var elementCount = 0
        
        for element in parsedFormula {
            currentLine.append(element)
            
            // Count non-operator elements
            switch element {
            case .coefficient, .subject, .maxFunction:
                elementCount += 1
            case .mathOperator:
                break
            }
            
            // Split after every 2 terms (coefficient + subject pairs)
            if case .mathOperator(let op) = element, op == "+", elementCount >= 2 {
                lines.append(currentLine)
                currentLine = []
                elementCount = 0
            }
        }
        
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }
        
        // If no split occurred, return the whole formula
        return lines.isEmpty ? [parsedFormula] : lines
    }
    
    private func parseFormula(_ formula: String) -> [FormulaElement] {
        var components: [FormulaElement] = []
        let cleanFormula = formula.replacingOccurrences(of: "W = ", with: "")
                                .replacingOccurrences(of: "W=", with: "")
        
        // Split by operators while keeping them
        let pattern = "([+\\-×*/()])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = cleanFormula as NSString
        let matches = regex?.matches(in: cleanFormula, options: [], range: NSRange(location: 0, length: nsString.length)) ?? []
        
        var lastEnd = 0
        
        for match in matches {
            let range = match.range
            
            // Add the part before the operator
            if range.location > lastEnd {
                let beforeRange = NSRange(location: lastEnd, length: range.location - lastEnd)
                let beforeText = nsString.substring(with: beforeRange).trimmingCharacters(in: .whitespaces)
                if !beforeText.isEmpty {
                    components.append(contentsOf: parseComponent(beforeText))
                }
            }
            
            // Add the operator
            let operatorText = nsString.substring(with: range)
            components.append(.mathOperator(operatorText))
            
            lastEnd = range.location + range.length
        }
        
        // Add the remaining part
        if lastEnd < nsString.length {
            let remainingText = nsString.substring(from: lastEnd).trimmingCharacters(in: .whitespaces)
            if !remainingText.isEmpty {
                components.append(contentsOf: parseComponent(remainingText))
            }
        }
        
        // If no operators were found, parse the whole formula
        if components.isEmpty {
            components = parseComponent(cleanFormula)
        }
        
        return components
    }
    
    private func parseComponent(_ text: String) -> [FormulaElement] {
        var components: [FormulaElement] = []
        
        // Check for coefficient × subject pattern
        if text.contains("×") || text.contains("*") {
            let parts = text.split(separator: text.contains("×") ? "×" : "*").map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                // Coefficient
                if let coefficient = Double(parts[0]) {
                    components.append(.coefficient(coefficient))
                    components.append(.mathOperator("×"))
                }
                // Subject
                components.append(.subject(formatSubject(parts[1])))
                return components
            }
        }
        
        // Check for max function
        if text.hasPrefix("max(") && text.hasSuffix(")") {
            let content = String(text.dropFirst(4).dropLast(1))
            let subjects = content.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            components.append(.maxFunction(subjects.map { formatSubject($0) }))
            return components
        }
        
        // Check if it's a number (coefficient without multiplication)
        if let number = Double(text) {
            components.append(.coefficient(number))
            return components
        }
        
        // Otherwise it's a subject (with possible level in parentheses)
        components.append(.subject(formatSubject(text)))
        return components
    }
    
    private func formatSubject(_ subject: String) -> (name: String, level: String) {
        // First, extract level from parentheses if present
        var cleanSubject = subject
        var level = ""
        
        // Check for (R) or (P) in parentheses - handle with or without spaces
        if subject.contains("(R)") || subject.contains("(r)") || subject.contains(" (R)") || subject.contains(" (r)") {
            level = "R"
            cleanSubject = subject.replacingOccurrences(of: " (R)", with: "")
                                 .replacingOccurrences(of: "(R)", with: "")
                                 .replacingOccurrences(of: " (r)", with: "")
                                 .replacingOccurrences(of: "(r)", with: "")
                                 .trimmingCharacters(in: .whitespaces)
        } else if subject.contains("(P)") || subject.contains("(p)") || subject.contains(" (P)") || subject.contains(" (p)") {
            level = "P"
            cleanSubject = subject.replacingOccurrences(of: " (P)", with: "")
                                 .replacingOccurrences(of: "(P)", with: "")
                                 .replacingOccurrences(of: " (p)", with: "")
                                 .replacingOccurrences(of: "(p)", with: "")
                                 .trimmingCharacters(in: .whitespaces)
        }
        
        let lowerSubject = cleanSubject.lowercased()
        
        // Map common abbreviations to short names
        let subjectMap: [String: String] = [
            "mat": "mat",
            "mat_r": "mat",
            "mat_p": "mat",
            "matematyka": "mat",
            "matematyka_r": "mat",
            "matematyka_p": "mat",
            "fiz": "fiz",
            "fiz_r": "fiz",
            "fizyka": "fiz",
            "fizyka_r": "fiz",
            "chem": "chem",
            "chem_r": "chem",
            "chemia": "chem",
            "chemia_r": "chem",
            "inf": "inf",
            "inf_r": "inf",
            "informatyka": "inf",
            "informatyka_r": "inf",
            "bio": "bio",
            "bio_r": "bio",
            "biologia": "bio",
            "biologia_r": "bio",
            "pol": "pol",
            "pol_r": "pol",
            "polski_r": "pol",
            "język polski": "pol",
            "j. polski": "pol",
            "ang": "ang",
            "ang_r": "ang",
            "angielski_r": "ang",
            "język angielski": "ang",
            "j. angielski": "ang",
            "język obcy": "j.ob",
            "język_obcy_r": "j.ob",
            "j. obcy": "j.ob",
            "geo": "geo",
            "geo_r": "geo",
            "geografia": "geo",
            "geografia_r": "geo",
            "hist": "hist",
            "hist_r": "hist",
            "historia": "hist",
            "historia_r": "hist",
            "wos": "WOS",
            "wos_r": "WOS"
        ]
        
        // If level wasn't already determined from parentheses, check other indicators
        if level.isEmpty {
            level = lowerSubject.contains("_r") || lowerSubject.contains("rozszerzony") ? "R" : 
                    lowerSubject.contains("_p") || lowerSubject.contains("podstawowy") ? "P" : ""
        }
        
        // Further clean subject name
        cleanSubject = cleanSubject
            .replacingOccurrences(of: "_r", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "_p", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "rozszerzony", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "podstawowy", with: "", options: .caseInsensitive)
            .trimmingCharacters(in: .whitespaces)
        
        // Map to short name if available
        if let mappedName = subjectMap[cleanSubject.lowercased()] {
            cleanSubject = mappedName
        }
        
        return (name: cleanSubject, level: level)
    }
}

// MARK: - Formula Elements
enum FormulaElement {
    case coefficient(Double)
    case subject((name: String, level: String))
    case mathOperator(String)
    case maxFunction([(name: String, level: String)])
    
    var view: some View {
        Group {
            switch self {
            case .coefficient(let value):
                Text(value == 1.0 ? "" : (value == floor(value) ? String(format: "%.0f", value) : String(format: "%.1f", value)))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                
            case .subject(let info):
                HStack(spacing: 0) {
                    Text(info.name)
                        .font(.system(size: 15))
                        .italic()
                    if !info.level.isEmpty {
                        Text(info.level)
                            .font(.system(size: 9, weight: .medium))
                            .baselineOffset(6)
                            .foregroundColor(.secondary)
                    }
                }
                
            case .mathOperator(let op):
                Text(op == "*" ? "×" : op)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
                
            case .maxFunction(let subjects):
                HStack(spacing: 0) {
                    Text("max")
                        .font(.system(size: 14, weight: .medium))
                        .italic()
                    Text("(")
                        .font(.system(size: 16))
                    ForEach(subjects.indices, id: \.self) { index in
                        HStack(spacing: 0) {
                            Text(subjects[index].name)
                                .font(.system(size: 14))
                                .italic()
                            if !subjects[index].level.isEmpty {
                                Text(subjects[index].level)
                                    .font(.system(size: 8, weight: .medium))
                                    .baselineOffset(5)
                                    .foregroundColor(.secondary)
                            }
                        }
                        if index < subjects.count - 1 {
                            Text(", ")
                                .font(.system(size: 14))
                        }
                    }
                    Text(")")
                        .font(.system(size: 16))
                }
            }
        }
    }
}

// MARK: - Styled Formula Card
struct FormulaCard: View {
    let formula: String
    let title: String = "Wzór rekrutacyjny"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "function")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .center, spacing: 8) {
                FormulaView(formula: formula)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.vertical, 4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Compact Formula View
struct CompactFormulaView: View {
    let formula: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text("W = ")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            
            FormulaView(formula: formula)
                .scaleEffect(0.8)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        FormulaCard(formula: "0.5 × matematyka (R) + 0.3 × fizyka (R) + 0.2 × język obcy (R)")
        
        FormulaCard(formula: "0.4 × MAT_R + 0.3 × FIZ_R + 0.3 × INF_R")
        
        FormulaCard(formula: "0.6 × matematyka (R) + 0.4 × max(fizyka, chemia, informatyka) (R)")
        
        FormulaCard(formula: "matematyka (R) + 0.5 × język polski (P)")
        
        // Compact versions
        Text("Compact versions:")
            .font(.headline)
            .padding(.top)
        
        VStack(alignment: .leading, spacing: 8) {
            CompactFormulaView(formula: "0.5 × matematyka (R) + 0.3 × fizyka (R)")
            CompactFormulaView(formula: "0.4 × MAT_R + 0.6 × FIZ_R")
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    .padding()
}