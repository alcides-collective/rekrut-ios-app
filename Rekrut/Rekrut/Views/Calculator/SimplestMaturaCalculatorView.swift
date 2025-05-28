//
//  SimplestMaturaCalculatorView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct SimplestMaturaCalculatorView: View {
    @State private var basicScores: [String: String] = [:]
    @State private var extendedScores: [String: String] = [:]
    @State private var showExtended = false
    @State private var showResults = false
    @State private var totalPoints: Double = 0
    
    let mandatorySubjects = [
        ("Polski", "polish"),
        ("Matematyka", "math"),
        ("Język obcy", "foreign")
    ]
    
    let additionalSubjects = [
        ("Biologia", "bio"),
        ("Chemia", "chem"),
        ("Fizyka", "phys"),
        ("Informatyka", "info"),
        ("Geografia", "geo"),
        ("Historia", "hist"),
        ("WOS", "wos")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Basic scores section
                VStack(alignment: .leading, spacing: 16) {
                        Text("Poziom podstawowy")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            ForEach(mandatorySubjects, id: \.1) { subject in
                                ScoreRow(
                                    subject: subject.0,
                                    score: Binding(
                                        get: { basicScores[subject.1] ?? "" },
                                        set: { basicScores[subject.1] = $0 }
                                    )
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Extended scores section
                    VStack(alignment: .leading, spacing: 16) {
                        Button(action: { withAnimation { showExtended.toggle() } }) {
                            HStack {
                                Text("Poziom rozszerzony")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: showExtended ? "chevron.up" : "chevron.down")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.primary)
                        
                        if showExtended {
                            VStack(spacing: 12) {
                                // Mandatory extended
                                ForEach(mandatorySubjects, id: \.1) { subject in
                                    ScoreRow(
                                        subject: subject.0,
                                        score: Binding(
                                            get: { extendedScores[subject.1] ?? "" },
                                            set: { extendedScores[subject.1] = $0 }
                                        ),
                                        isOptional: true
                                    )
                                }
                                
                                Divider()
                                
                                // Additional subjects
                                Text("Przedmioty dodatkowe")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                ForEach(additionalSubjects, id: \.1) { subject in
                                    ScoreRow(
                                        subject: subject.0,
                                        score: Binding(
                                            get: { extendedScores[subject.1] ?? "" },
                                            set: { extendedScores[subject.1] = $0 }
                                        ),
                                        isOptional: true
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Calculate button
                    Button(action: calculate) {
                        Text("Oblicz punkty")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(hasRequiredScores() ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!hasRequiredScores())
                    
                    // Results
                    if showResults {
                        VStack(spacing: 12) {
                            Text("Twój wynik")
                                .font(.headline)
                            
                            Text("\(Int(totalPoints))")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                            
                            Text("punktów rekrutacyjnych")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Wynik obliczony według standardowego wzoru")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.white)
            .navigationTitle("Matury")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func hasRequiredScores() -> Bool {
        mandatorySubjects.allSatisfy { subject in
            if let score = basicScores[subject.1], !score.isEmpty, Int(score) != nil {
                return true
            }
            return false
        }
    }
    
    private func calculate() {
        var points = 0.0
        
        // Basic level calculation (0.1 multiplier)
        for subject in mandatorySubjects {
            if let scoreStr = basicScores[subject.1],
               let score = Double(scoreStr) {
                points += score * 0.1
            }
        }
        
        // Extended level calculation (0.3-0.4 multiplier)
        for subject in mandatorySubjects {
            if let scoreStr = extendedScores[subject.1],
               let score = Double(scoreStr) {
                let multiplier = subject.1 == "math" ? 0.35 : 0.3
                points += score * multiplier
            }
        }
        
        // Additional subjects (best one, 0.2 multiplier)
        var bestAdditional = 0.0
        for subject in additionalSubjects {
            if let scoreStr = extendedScores[subject.1],
               let score = Double(scoreStr) {
                bestAdditional = max(bestAdditional, score)
            }
        }
        points += bestAdditional * 0.2
        
        totalPoints = points
        withAnimation {
            showResults = true
        }
    }
}

struct ScoreRow: View {
    let subject: String
    @Binding var score: String
    var isOptional: Bool = false
    @FocusState private var isFocused: Bool
    
    var isValid: Bool {
        guard !score.isEmpty else { return true }
        guard let value = Int(score) else { return false }
        return value >= 0 && value <= 100
    }
    
    var body: some View {
        HStack {
            Text(subject)
                .font(.body)
                .frame(minWidth: 100, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 4) {
                TextField(isOptional ? "—" : "0", text: $score)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 50)
                    .focused($isFocused)
                    .onChange(of: score) { newValue in
                        // Only allow numbers
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            score = filtered
                        }
                        // Limit to 100
                        if let value = Int(filtered), value > 100 {
                            score = "100"
                        }
                    }
                
                Text("%")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        !isValid ? Color.red :
                        isFocused ? Color.blue :
                        Color(.systemGray4),
                        lineWidth: isFocused ? 2 : 1
                    )
            )
        }
    }
}

#Preview {
    SimplestMaturaCalculatorView()
}