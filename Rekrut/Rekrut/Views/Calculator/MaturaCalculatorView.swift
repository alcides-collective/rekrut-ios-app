//
//  MaturaCalculatorView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct MaturaCalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var selectedTab = 0
    @State private var showingProgramSelection = false
    @State private var showingResults = false
    
    var body: some View {
            VStack {
                if viewModel.selectedPrograms.isEmpty {
                    EmptyStateView(showingProgramSelection: $showingProgramSelection)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            SelectedProgramsCard(
                                programs: viewModel.selectedPrograms,
                                showingProgramSelection: $showingProgramSelection
                            )
                            
                            MaturaScoresSection(viewModel: viewModel)
                            
                            CalculateButton(viewModel: viewModel, showingResults: $showingResults)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Kalkulator Maturalny")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingProgramSelection) {
                ProgramSelectionView(selectedPrograms: $viewModel.selectedPrograms)
            }
            .sheet(isPresented: $showingResults) {
                CalculationResultsView(results: viewModel.calculationResults)
            }
        .onAppear {
            viewModel.loadSavedScores()
        }
    }
}

struct EmptyStateView: View {
    @Binding var showingProgramSelection: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "function")
                .font(.system(size: 80))
                .foregroundColor(.blue.opacity(0.5))
            
            Text("Kalkulator Punktów")
                .font(.title)
                .bold()
            
            Text("Wybierz kierunki studiów, aby obliczyć swoje szanse na dostanie się")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                showingProgramSelection = true
            }) {
                Label("Wybierz kierunki", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct SelectedProgramsCard: View {
    let programs: [StudyProgram]
    @Binding var showingProgramSelection: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Wybrane kierunki")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    showingProgramSelection = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            
            ForEach(programs) { program in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(program.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(program.field)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 10)
    }
}

struct MaturaScoresSection: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @State private var showingSubjectPicker = false
    @State private var selectedSubject: MaturaSubject?
    
    var mandatoryScores: [MaturaSubjectScore] {
        viewModel.maturaScores.subjects.filter { $0.subject.isMandatory }
            .sorted { $0.subject.rawValue < $1.subject.rawValue }
    }
    
    var additionalScores: [MaturaSubjectScore] {
        viewModel.maturaScores.subjects.filter { !$0.subject.isMandatory }
            .sorted { $0.subject.rawValue < $1.subject.rawValue }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Wyniki egzaminów maturalnych")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    showingSubjectPicker = true
                }) {
                    Label("Dodaj", systemImage: "plus.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            if viewModel.maturaScores.subjects.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("Nie dodano jeszcze żadnych wyników")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Dodaj wyniki z Twojego świadectwa maturalnego")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    // Mandatory subjects
                    if !mandatoryScores.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Text("Przedmioty obowiązkowe")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                            
                            ForEach(mandatoryScores) { score in
                                MaturaScoreRow(score: score, viewModel: viewModel)
                            }
                        }
                    }
                    
                    // Additional subjects
                    if !additionalScores.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Przedmioty dodatkowe")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            ForEach(additionalScores) { score in
                                MaturaScoreRow(score: score, viewModel: viewModel)
                            }
                        }
                    }
                }
            }
            
            // Info box
            if !viewModel.maturaScores.subjects.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Wyniki są przeliczane na punkty rekrutacyjne według wzorów poszczególnych uczelni")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 10)
        .sheet(isPresented: $showingSubjectPicker) {
            SubjectPickerView(viewModel: viewModel)
        }
    }
}

struct MaturaScoreRow: View {
    let score: MaturaSubjectScore
    let viewModel: CalculatorViewModel
    
    var scoreColor: Color {
        if score.subject.isMandatory && score.scorePercentage < 30 {
            return .red
        } else if score.scorePercentage >= 80 {
            return .green
        } else if score.scorePercentage >= 50 {
            return .blue
        } else {
            return .orange
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(score.subject.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if score.subject.isMandatory {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
                
                HStack(spacing: 4) {
                    Text(score.level.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(score.level.shortName)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(score.scorePercentage))%")
                    .font(.headline)
                    .foregroundColor(scoreColor)
                
                if score.subject.isMandatory && score.scorePercentage < 30 {
                    Text("Niezdany")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
            
            Button(action: {
                viewModel.removeScore(subject: score.subject, level: score.level)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct CalculateButton: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @Binding var showingResults: Bool
    
    var body: some View {
        Button(action: {
            Task {
                await viewModel.calculatePoints()
                showingResults = true
            }
        }) {
            if viewModel.isCalculating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text("Oblicz punkty")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(viewModel.maturaScores.subjects.isEmpty ? Color.gray : Color.blue)
        .cornerRadius(10)
        .disabled(viewModel.maturaScores.subjects.isEmpty || viewModel.isCalculating)
    }
}

#Preview {
    MaturaCalculatorView()
}