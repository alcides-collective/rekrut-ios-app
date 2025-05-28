//
//  CompactMaturaCalculatorView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct CompactMaturaCalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var showingProgramSelection = false
    @State private var showingResults = false
    @State private var maturaScores: [String: String] = [:]
    @State private var expandedExtendedScores = false
    @State private var selectedAdditionalSubjects: Set<MaturaSubject> = []
    
    let mandatorySubjects: [MaturaSubject] = [.polish, .mathematics, .foreignLanguage]
    let additionalSubjects: [MaturaSubject] = [.biology, .chemistry, .physics, .computerScience, .history, .geography]
    
    var body: some View {
        VStack(spacing: 0) {
            // Ultra-compact header
            HStack {
                Text("Kalkulator Maturalny")
                    .font(.headline)
                    .bold()
                
                Spacer()
                
                Button(action: { showingProgramSelection = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                            .font(.caption)
                        Group {
                            if viewModel.selectedPrograms.isEmpty {
                                Text("Wybierz kierunek")
                                    .font(.caption)
                                    .bold()
                            } else {
                                Text("\(viewModel.selectedPrograms.count) kier.")
                                    .font(.caption)
                                    .bold()
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            
            ScrollView {
                VStack(spacing: 12) {
                    // Ultra-compact info
                    if !viewModel.selectedPrograms.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .font(.caption2)
                            Text("Wprowadź wyniki procentowe z matury")
                                .font(.caption2)
                            Spacer()
                        }
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    }
                    
                    // Mandatory subjects - Basic level
                    VStack(spacing: 0) {
                        HStack {
                            Label {
                                Text("Przedmioty obowiązkowe")
                                    .font(.caption)
                                    .bold()
                            } icon: {
                                Image(systemName: "star.fill")
                            }
                                .foregroundColor(.orange)
                            Spacer()
                            Text("Poziom podstawowy")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        
                        // Basic level inputs in one row
                        HStack(spacing: 0) {
                            ForEach(mandatorySubjects, id: \.self) { subject in
                                UltraCompactScoreInput(
                                    subject: getShortName(for: subject),
                                    level: "PP",
                                    key: "\(subject.rawValue)_\(MaturaLevel.basic.rawValue)",
                                    scores: $maturaScores,
                                    isMandatory: true
                                )
                                
                                if subject != mandatorySubjects.last {
                                    Divider()
                                        .frame(height: 40)
                                }
                            }
                        }
                        .background(Color(.systemGray6))
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    // Extended level - Collapsible
                    VStack(spacing: 0) {
                        Button(action: { withAnimation(.easeInOut(duration: 0.2)) { expandedExtendedScores.toggle() } }) {
                            HStack {
                                Text("Poziom rozszerzony")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.primary)
                                
                                Text("(opcjonalnie)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Image(systemName: expandedExtendedScores ? "chevron.up" : "chevron.down")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                        
                        if expandedExtendedScores {
                            VStack(spacing: 8) {
                                Text("Wypełnij jeśli zdawałeś")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 0) {
                                    ForEach(mandatorySubjects, id: \.self) { subject in
                                        UltraCompactScoreInput(
                                            subject: getShortName(for: subject),
                                            level: "PR",
                                            key: "\(subject.rawValue)_\(MaturaLevel.extended.rawValue)",
                                            scores: $maturaScores,
                                            isOptional: true
                                        )
                                        
                                        if subject != mandatorySubjects.last {
                                            Divider()
                                                .frame(height: 40)
                                        }
                                    }
                                }
                                .background(Color(.systemBackground))
                                .cornerRadius(6)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    // Additional subjects
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Przedmioty dodatkowe")
                                .font(.caption)
                                .bold()
                            Text("PR")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Subject chips in 2 columns
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                            ForEach(additionalSubjects, id: \.self) { subject in
                                MiniSubjectChip(
                                    subject: getShortName(for: subject),
                                    isSelected: selectedAdditionalSubjects.contains(subject),
                                    onTap: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            if selectedAdditionalSubjects.contains(subject) {
                                                selectedAdditionalSubjects.remove(subject)
                                                maturaScores["\(subject.rawValue)_\(MaturaLevel.extended.rawValue)"] = ""
                                            } else {
                                                selectedAdditionalSubjects.insert(subject)
                                            }
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Selected subject inputs
                        if !selectedAdditionalSubjects.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(Array(selectedAdditionalSubjects), id: \.self) { subject in
                                        UltraCompactScoreInput(
                                            subject: getShortName(for: subject),
                                            level: "PR",
                                            key: "\(subject.rawValue)_\(MaturaLevel.extended.rawValue)",
                                            scores: $maturaScores,
                                            isOptional: true
                                        )
                                        .background(Color(.systemBackground))
                                        .cornerRadius(6)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            // Calculate button
            VStack(spacing: 0) {
                Divider()
                
                Button(action: { calculatePoints() }) {
                    Text("Oblicz punkty rekrutacyjne")
                        .font(.subheadline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(canCalculate() ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!canCalculate())
                .padding()
            }
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingProgramSelection) {
            ProgramSelectionView(selectedPrograms: $viewModel.selectedPrograms)
        }
        .sheet(isPresented: $showingResults) {
            CalculationResultsView(results: viewModel.calculationResults)
        }
    }
    
    private func getShortName(for subject: MaturaSubject) -> String {
        switch subject {
        case .polish: return "Polski"
        case .mathematics: return "Matma"
        case .foreignLanguage: return "J. obcy"
        case .biology: return "Bio"
        case .chemistry: return "Chem"
        case .physics: return "Fiz"
        case .computerScience: return "Info"
        case .history: return "Hist"
        case .geography: return "Geo"
        default: return String(subject.rawValue.prefix(4))
        }
    }
    
    private func canCalculate() -> Bool {
        !viewModel.selectedPrograms.isEmpty && hasBasicScores()
    }
    
    private func hasBasicScores() -> Bool {
        mandatorySubjects.allSatisfy { subject in
            let key = "\(subject.rawValue)_\(MaturaLevel.basic.rawValue)"
            return !(maturaScores[key] ?? "").isEmpty
        }
    }
    
    private func calculatePoints() {
        saveScoresToViewModel()
        Task {
            await viewModel.calculatePoints()
            showingResults = true
        }
    }
    
    private func saveScoresToViewModel() {
        viewModel.maturaScores.subjects.removeAll()
        
        for (key, value) in maturaScores {
            guard !value.isEmpty, let percentage = Double(value) else { continue }
            
            let parts = key.split(separator: "_")
            guard parts.count == 2,
                  let subject = MaturaSubject.allCases.first(where: { $0.rawValue == String(parts[0]) }),
                  let level = MaturaLevel.allCases.first(where: { $0.rawValue == String(parts[1]) }) else { continue }
            
            viewModel.addScore(subject: subject, level: level, percentage: percentage)
        }
    }
}

// Ultra-compact score input
struct UltraCompactScoreInput: View {
    let subject: String
    let level: String
    let key: String
    @Binding var scores: [String: String]
    var isMandatory: Bool = false
    var isOptional: Bool = false
    @FocusState private var isFocused: Bool
    
    var score: Binding<String> {
        Binding(
            get: { scores[key] ?? "" },
            set: { scores[key] = $0 }
        )
    }
    
    var scoreValue: Double? {
        Double(score.wrappedValue)
    }
    
    var isPassing: Bool {
        guard let value = scoreValue else { return true }
        return value >= 30
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Text(subject)
                .font(.caption2)
                .bold()
            
            Text(level)
                .font(.system(size: 9))
                .foregroundColor(.secondary)
            
            HStack(spacing: 1) {
                TextField("—", text: score)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .frame(width: 35)
                    .focused($isFocused)
                    .onChange(of: score.wrappedValue) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            score.wrappedValue = filtered
                        }
                        if let value = Int(filtered), value > 100 {
                            score.wrappedValue = "100"
                        }
                    }
                
                Text("%")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            
            // Warning indicator
            if isMandatory && !score.wrappedValue.isEmpty && !isPassing {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.orange)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(isOptional && score.wrappedValue.isEmpty ? Color.clear : Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(
                    isFocused ? Color.blue :
                    (isMandatory && !score.wrappedValue.isEmpty && !isPassing ? Color.orange :
                    (isOptional ? Color.clear : Color(.systemGray4))),
                    lineWidth: isFocused ? 2 : 1
                )
        )
    }
}

// Mini subject selection chip
struct MiniSubjectChip: View {
    let subject: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 3) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                }
                Group {
                    if isSelected {
                        Text(subject)
                            .font(.caption2)
                            .bold()
                    } else {
                        Text(subject)
                            .font(.caption2)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.blue.opacity(0.15) : Color(.systemGray5))
            .foregroundColor(isSelected ? .blue : .primary)
            .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        CompactMaturaCalculatorView()
    }
}