//
//  ProgramSelectionView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct ProgramSelectionView: View {
    @Binding var selectedPrograms: [StudyProgram]
    @State private var searchText = ""
    @State private var programs: [StudyProgram] = []
    @State private var universities: [University] = []
    @State private var isLoading = true
    @State private var selectedUniversityId: String? = nil
    @Environment(\.dismiss) private var dismiss
    
    private let mockData = MockDataService.shared
    
    var filteredPrograms: [StudyProgram] {
        programs.filter { program in
            let matchesSearch = searchText.isEmpty ||
                program.name.localizedCaseInsensitiveContains(searchText) ||
                program.field.localizedCaseInsensitiveContains(searchText)
            
            let matchesUniversity = selectedUniversityId == nil ||
                program.universityId == selectedUniversityId
            
            return matchesSearch && matchesUniversity
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Szukaj kierunku...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                // University filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "Wszystkie",
                            isSelected: selectedUniversityId == nil,
                            action: { selectedUniversityId = nil }
                        )
                        
                        ForEach(universities) { university in
                            FilterChip(
                                title: university.shortName ?? university.name,
                                isSelected: selectedUniversityId == university.id,
                                action: { selectedUniversityId = university.id }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Programs list
                if isLoading {
                    Spacer()
                    ProgressView("Ładowanie kierunków...")
                    Spacer()
                } else {
                    List {
                        ForEach(filteredPrograms) { program in
                            ProgramRow(
                                program: program,
                                university: universities.first { $0.id == program.universityId },
                                isSelected: selectedPrograms.contains { $0.id == program.id },
                                action: { toggleProgram(program) }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                // Bottom bar
                VStack(spacing: 16) {
                    HStack {
                        Text("Wybrano: \(selectedPrograms.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if selectedPrograms.count > 0 {
                            Button("Wyczyść") {
                                selectedPrograms.removeAll()
                            }
                            .font(.subheadline)
                            .foregroundColor(.red)
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Gotowe")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedPrograms.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(selectedPrograms.isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            }
            .navigationTitle("Wybierz kierunki")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        // In real app, this would fetch from Firebase
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.programs = mockData.mockPrograms
            self.universities = mockData.mockUniversities
            self.isLoading = false
        }
    }
    
    private func toggleProgram(_ program: StudyProgram) {
        if let index = selectedPrograms.firstIndex(where: { $0.id == program.id }) {
            selectedPrograms.remove(at: index)
        } else {
            selectedPrograms.append(program)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ProgramRow: View {
    let program: StudyProgram
    let university: University?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(program.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(university?.displayName ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        Label(program.degree.rawValue, systemImage: "graduationcap")
                            .font(.caption)
                        
                        Label(program.mode.rawValue, systemImage: "clock")
                            .font(.caption)
                        
                        if let threshold = program.lastYearThreshold {
                            Label("\(Int(threshold)) pkt", systemImage: "chart.line.uptrend.xyaxis")
                                .font(.caption)
                                .foregroundColor(.blue)
                        } else {
                            Label("Brak danych", systemImage: "questionmark.circle")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProgramSelectionView(selectedPrograms: .constant([]))
}