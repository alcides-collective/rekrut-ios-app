//
//  UniversityDetailView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct UniversityDetailView: View {
    let university: University
    @State private var programs: [StudyProgram] = []
    @State private var isLoading = true
    @State private var selectedTab = 0
    @StateObject private var firebaseService = FirebaseService.shared
    
    private let mockData = MockDataService.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                UniversityHeaderView(university: university)
                
                // Quick stats
                UniversityStatsView(university: university, programCount: programs.count)
                
                // Tab selection
                Picker("", selection: $selectedTab) {
                    Text("O uczelni").tag(0)
                    Text("Kierunki (\(programs.count))").tag(1)
                    Text("Kontakt").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Tab content
                switch selectedTab {
                case 0:
                    AboutUniversityView(university: university)
                case 1:
                    ProgramsListView(programs: programs, university: university)
                case 2:
                    ContactInfoView(university: university)
                default:
                    EmptyView()
                }
            }
        }
        .navigationTitle(university.shortName ?? university.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadPrograms()
        }
    }
    
    private func loadPrograms() {
        // In real app, this would fetch from Firebase
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.programs = mockData.mockPrograms.filter { $0.universityId == university.id }
            self.isLoading = false
        }
    }
}

struct UniversityHeaderView: View {
    let university: University
    
    var body: some View {
        VStack(spacing: 16) {
            // Logo placeholder
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 100, height: 100)
                .overlay(
                    Text(university.shortName ?? String(university.name.prefix(2)))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                )
            
            Text(university.name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                Label(university.city, systemImage: "mappin")
                Label(university.type.rawValue, systemImage: "building.2")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct UniversityStatsView: View {
    let university: University
    let programCount: Int
    
    var body: some View {
        HStack(spacing: 0) {
            StatItemView(
                value: university.ranking.map { "#\($0)" } ?? "-",
                label: "Ranking",
                systemImage: "trophy.fill",
                color: .orange
            )
            
            Divider()
                .frame(height: 40)
            
            StatItemView(
                value: university.studentCount.map { "\($0 / 1000)k" } ?? "-",
                label: "Studentów",
                systemImage: "person.3.fill",
                color: .blue
            )
            
            Divider()
                .frame(height: 40)
            
            StatItemView(
                value: "\(programCount)",
                label: "Kierunków",
                systemImage: "book.fill",
                color: .green
            )
            
            Divider()
                .frame(height: 40)
            
            StatItemView(
                value: university.establishedYear.map { "\($0)" } ?? "-",
                label: "Rok założenia",
                systemImage: "calendar",
                color: .purple
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct StatItemView: View {
    let value: String
    let label: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct AboutUniversityView: View {
    let university: University
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let description = university.description {
                VStack(alignment: .leading, spacing: 12) {
                    Text("O uczelni")
                        .font(.headline)
                    
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Informacje")
                    .font(.headline)
                
                InfoRowView(label: "Typ", value: university.isPublic ? "Publiczna" : "Prywatna")
                InfoRowView(label: "Województwo", value: university.voivodeship)
                InfoRowView(label: "Adres", value: university.address)
                
                if let website = university.website {
                    Link(destination: URL(string: website)!) {
                        HStack {
                            Text("Strona internetowa")
                            Spacer()
                            Image(systemName: "link")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ProgramsListView: View {
    let programs: [StudyProgram]
    let university: University
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if programs.isEmpty {
                Text("Brak dostępnych kierunków")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                ForEach(programs) { program in
                    NavigationLink(destination: ProgramDetailView(program: program, university: university)) {
                        ProgramCardView(program: program)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ProgramCardView: View {
    let program: StudyProgram
    @StateObject private var firebaseService = FirebaseService.shared
    @StateObject private var localStorage = LocalStorageService.shared
    
    // Calculate user's progress based on their matura scores
    private var userProgress: Double? {
        guard program.lastYearThreshold != nil else { return nil }
        
        // Get matura scores from Firebase or local storage
        var maturaScores: MaturaScores? = nil
        
        if let user = firebaseService.currentUser,
           let userScores = user.maturaScores {
            maturaScores = userScores
        } else {
            // Try local storage if not logged in - now reactive!
            maturaScores = localStorage.maturaScores
        }
        
        guard let scores = maturaScores,
              hasEnteredScores(scores) else {
            return nil
        }
        
        return program.calculateProgress(maturaScores: scores)
    }
    
    private func hasEnteredScores(_ maturaScores: MaturaScores) -> Bool {
        // Check if user has entered any matura scores
        return maturaScores.polishBasic != nil ||
               maturaScores.mathematicsBasic != nil ||
               maturaScores.polish != nil ||
               maturaScores.mathematics != nil ||
               maturaScores.foreignLanguageBasic != nil ||
               maturaScores.foreignLanguage != nil ||
               maturaScores.physics != nil ||
               maturaScores.computerScience != nil ||
               maturaScores.chemistry != nil ||
               maturaScores.biology != nil
    }
    
    private func getProgressColor() -> Color {
        if let progress = userProgress {
            if progress >= 1.0 {
                return .green
            } else if progress >= 0.8 {
                return .yellow
            } else {
                return .red
            }
        }
        // Gray color if no user data entered
        return .gray
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(program.name)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                Label(program.degree.rawValue, systemImage: "graduationcap")
                Label("\(program.durationSemesters) sem.", systemImage: "clock")
                Label(program.mode.rawValue, systemImage: "person.fill")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            HStack {
                Text("Próg punktowy z zeszłego roku:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let threshold = program.lastYearThreshold {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(getProgressColor())
                            .frame(width: 6, height: 6)
                        
                        if let progress = userProgress, progress > 1.0 {
                            Text("+\(Int((progress - 1.0) * 100))%")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        } else if userProgress == nil {
                            Text("Wprowadź maturę")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                        } else {
                            Text("\(Int(threshold)) pkt")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text("Brak danych")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ContactInfoView: View {
    let university: University
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Dane kontaktowe")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 16) {
                ContactRowView(
                    icon: "mappin.circle.fill",
                    label: "Adres",
                    value: "\(university.address)\n\(university.city), \(university.voivodeship)"
                )
                
                if let website = university.website {
                    ContactRowView(
                        icon: "globe",
                        label: "Strona internetowa",
                        value: website,
                        isLink: true
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct InfoRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

struct ContactRowView: View {
    let icon: String
    let label: String
    let value: String
    var isLink: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if isLink, let url = URL(string: value) {
                    Link(value, destination: url)
                        .font(.subheadline)
                } else {
                    Text(value)
                        .font(.subheadline)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        UniversityDetailView(university: MockDataService.shared.mockUniversities.first!)
    }
}
