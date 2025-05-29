//
//  AIMatchResultsView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct AIMatchResultsView: View {
    let answers: [String: Any]
    @State private var isLoading = true
    @State private var matchedPrograms: [(program: StudyProgram, score: Int, reasons: [String])] = []
    @State private var selectedTab = 0
    @State private var showShareSheet = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header - Left aligned, minimal
                        ResultsHeaderView(
                            topMatch: matchedPrograms.first,
                            onShare: { showShareSheet = true }
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Results
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Twoje dopasowania")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 24)
                            
                            // Top matches with images
                            VStack(spacing: 16) {
                                ForEach(Array(matchedPrograms.prefix(10).enumerated()), id: \.element.program.id) { index, match in
                                    AIMatchProgramCard(
                                        program: match.program,
                                        university: MockDataService.shared.mockUniversities.first { $0.id == match.program.universityId }!,
                                        score: match.score,
                                        rank: index + 1,
                                        reasons: match.reasons
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Insights section
                        PersonalityInsightsSection(answers: answers)
                            .padding(.top, 20)
                    }
                    .padding(.bottom, 40)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [generateShareText()])
        }
        .onAppear {
            generateDetailedResults()
        }
    }
    
    private func generateDetailedResults() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.spring()) {
                self.matchedPrograms = generateMatchesWithReasons()
                self.isLoading = false
            }
        }
    }
    
    private func generateMatchesWithReasons() -> [(program: StudyProgram, score: Int, reasons: [String])] {
        let programs = MockDataService.shared.mockPrograms
        
        return programs.map { program in
            var score = Int.random(in: 65...98)
            var reasons: [String] = []
            
            // Generate personalized reasons based on answers
            if let subjects = answers["subjects"] as? Set<String> {
                if subjects.contains("Matematyka i fizyka") && program.field.contains("Informatyka") {
                    score += 5
                    reasons.append("Matematyka i fizyka to świetna podstawa")
                }
                if subjects.contains("Biologia i chemia") && program.field.contains("Medycyna") {
                    score += 5
                    reasons.append("Biologia i chemia to klucz do medycyny")
                }
            }
            
            if let priorities = answers["priorities"] as? Set<String> {
                if priorities.contains("Prestiż uczelni") && ["UW", "UJ", "PW"].contains(program.universityId) {
                    score += 3
                    reasons.append("Prestiżowa uczelnia")
                }
            }
            
            if let location = answers["location"] as? String {
                if location.contains("dużym mieście") && ["Warszawa", "Kraków", "Wrocław"].contains(MockDataService.shared.mockUniversities.first { $0.id == program.universityId }?.city ?? "") {
                    score += 2
                    reasons.append("Studia w dużym mieście")
                }
            }
            
            // Add generic reasons if needed
            if reasons.isEmpty {
                reasons = [
                    "Dopasowany do Twoich zainteresowań",
                    "Zgodny z Twoimi priorytetami"
                ]
            }
            
            return (program, min(score, 98), reasons)
        }
        .sorted { $0.1 > $1.1 }
    }
    
    private func generateShareText() -> String {
        guard let topMatch = matchedPrograms.first else { return "" }
        return """
        Moje wyniki AI Match w aplikacji Rekrut:
        
        Top dopasowanie: \(topMatch.program.name) (\(topMatch.score)%)
        Uczelnia: \(MockDataService.shared.mockUniversities.first { $0.id == topMatch.program.universityId }?.name ?? "")
        
        Odkryj swój idealny kierunek studiów z Rekrut!
        rekrut.app
        """
    }
}

// Minimal loading view
struct LoadingView: View {
    @State private var animationPhase = 0
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
            
            Text("Analizuję Twoje odpowiedzi...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// Clean, left-aligned header
struct ResultsHeaderView: View {
    let topMatch: (program: StudyProgram, score: Int, reasons: [String])?
    let onShare: () -> Void
    
    var body: some View {
        if let match = topMatch {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    // Score badge
                    ZStack {
                        Circle()
                            .fill(scoreColor(for: match.score))
                            .frame(width: 56, height: 56)
                        
                        Text("\(match.score)%")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Najlepsze dopasowanie")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(match.program.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        Text(MockDataService.shared.mockUniversities.first { $0.id == match.program.universityId }?.displayName ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private func scoreColor(for score: Int) -> Color {
        if score >= 90 {
            return .green
        } else if score >= 80 {
            return .orange
        } else {
            return .purple
        }
    }
}

// Panel-style program card matching Explore page design
struct AIMatchProgramCard: View {
    let program: StudyProgram
    let university: University
    let score: Int
    let rank: Int
    let reasons: [String]
    @State private var imageLoadFailed = false
    @State private var showingDetail = false
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
        Button(action: {
            showingDetail = true
        }) {
            VStack(spacing: 0) {
                // Image with gradient overlay
                ZStack(alignment: .bottomLeading) {
                    Group {
                        if let imageURL = program.imageURL ?? program.thumbnailURL,
                           !imageLoadFailed,
                           let url = URL(string: imageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure(_):
                                    programGradient
                                        .onAppear { imageLoadFailed = true }
                                case .empty:
                                    Color.gray.opacity(0.1)
                                @unknown default:
                                    programGradient
                                }
                            }
                        } else {
                            programGradient
                        }
                    }
                    .frame(height: 180)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0),
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.7)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Rank badge overlay
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                if rank <= 3 {
                                    Circle()
                                        .fill(rankColor)
                                        .frame(width: 36, height: 36)
                                    
                                    Text("\(rank)")
                                        .font(.system(.subheadline, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                } else {
                                    Circle()
                                        .fill(Color.black.opacity(0.5))
                                        .frame(width: 36, height: 36)
                                    
                                    Text("\(rank)")
                                        .font(.system(.subheadline, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.trailing, 12)
                            .padding(.top, 12)
                        }
                        Spacer()
                    }
                    
                    // Title overlay
                    VStack(alignment: .leading, spacing: 4) {
                        if let faculty = program.faculty {
                            Text(faculty)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Text(program.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(university.displayName)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(16)
                }
                
                // Bottom section
                VStack(spacing: 12) {
                    // Match score with reason
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Circle()
                                .fill(scoreColor)
                                .frame(width: 8, height: 8)
                            
                            Text("\(score)% dopasowania")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(scoreColor)
                            
                            Spacer()
                        }
                        
                        if let firstReason = reasons.first {
                            Text(firstReason)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    // Info pills
                    HStack(spacing: 8) {
                        if let threshold = program.lastYearThreshold {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(getProgressColor())
                                    .frame(width: 6, height: 6)
                                
                                if let progress = userProgress, progress > 1.0 {
                                    Text("+\(Int((progress - 1.0) * 100))%")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.green)
                                } else if userProgress == nil {
                                    Text("Wprowadź maturę")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("\(Int(threshold)) pkt")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(16)
                        } else {
                            InfoPill(
                                icon: "questionmark.circle",
                                text: "Brak danych"
                            )
                        }
                        
                        if let slots = program.availableSlots {
                            InfoPill(
                                icon: "person.2",
                                text: "\(slots) miejsc"
                            )
                        }
                        
                        InfoPill(
                            icon: "clock",
                            text: "\(program.durationSemesters) sem."
                        )
                        
                        Spacer()
                    }
                }
                .padding(16)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                ProgramDetailView(program: program, university: university)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Zamknij") {
                                showingDetail = false
                            }
                        }
                    }
            }
        }
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(.systemGray)
        case 3: return .orange
        default: return .purple
        }
    }
    
    private var scoreColor: Color {
        if score >= 90 {
            return .green
        } else if score >= 80 {
            return .orange
        } else {
            return .purple
        }
    }
    
    private var programGradient: LinearGradient {
        let colors: [Color] = [.blue, .purple, .pink, .orange].shuffled()
        return LinearGradient(
            gradient: Gradient(colors: [colors[0].opacity(0.6), colors[1].opacity(0.4)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct InfoPill: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
    }
}

// Minimal insights section
struct PersonalityInsightsSection: View {
    let answers: [String: Any]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Twój profil")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 24)
            
            VStack(spacing: 12) {
                InsightRow(
                    icon: "star.fill",
                    title: "Mocne strony",
                    description: generateStrengths(),
                    color: .yellow
                )
                
                InsightRow(
                    icon: "location.fill",
                    title: "Preferowane środowisko",
                    description: generateEnvironment(),
                    color: .blue
                )
                
                InsightRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Ścieżka rozwoju",
                    description: "Rozwijaj kompetencje praktyczne poprzez staże i projekty studenckie",
                    color: .green
                )
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func generateStrengths() -> String {
        if let subjects = answers["subjects"] as? Set<String> {
            if subjects.contains("Matematyka i fizyka") {
                return "Analityczne myślenie i rozwiązywanie problemów"
            } else if subjects.contains("Języki i historia") {
                return "Komunikacja i myślenie krytyczne"
            }
        }
        return "Wszechstronny profil z potencjałem rozwoju"
    }
    
    private func generateEnvironment() -> String {
        if let location = answers["location"] as? String {
            if location.contains("dużym mieście") {
                return "Dynamiczne środowisko miejskie z wieloma możliwościami"
            }
        }
        return "Środowisko sprzyjające rozwojowi i nauce"
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        AIMatchResultsView(
            answers: [
                "subjects": Set(["Matematyka i fizyka", "Informatyka"]),
                "priorities": Set(["Prestiż uczelni", "Wysokie zarobki"]),
                "location": "Chcę studiować w dużym mieście",
                "skills": [
                    "Programowanie": 4.5,
                    "Analiza danych": 4.0,
                    "Praca zespołowa": 3.5,
                    "Kreatywność": 4.0,
                    "Języki obce": 3.0
                ]
            ]
        )
    }
}