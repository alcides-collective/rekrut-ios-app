//
//  ProgramDetailView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// Simple iOS 15 compatible wrapping layout
struct WrappingHStack<Content: View>: View {
    let content: Content
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        // For iOS 15, we'll use a simpler approach with multiple HStacks
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
    }
}

struct ProgramDetailView: View {
    let program: StudyProgram
    let university: University
    @StateObject private var firebaseService = FirebaseService.shared
    @State private var isSaved = false
    @State private var showingLoginAlert = false
    @State private var showingProfile = false
    
    init(program: StudyProgram, university: University) {
        self.program = program
        self.university = university
        
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                ProgramHeroView(
                    program: program, 
                    university: university, 
                    isSaved: isSaved, 
                    toggleSave: toggleSave
                )
                .overlay(
                    // Essential Info Pills overlaid at bottom
                    VStack {
                        Spacer()
                        ProgramEssentialsView(program: program)
                            .padding(.bottom, 20)
                    }
                )
                
                VStack(alignment: .leading, spacing: 24) {
                    // Admission Progress (moved from ProgramEssentialsView)
                    if let threshold = program.lastYearThreshold {
                        AdmissionProgressView(threshold: threshold, applicationURL: program.applicationURL, program: program)
                    } else {
                        NoThresholdInfoView(applicationURL: program.applicationURL, program: program)
                    }
                    
                    // Description
                    if let description = program.description {
                        ProgramDescriptionView(description: description)
                    }
                    
                    // Admission Details
                    ProgramAdmissionView(program: program)
                    
                    // Tags
                    if !program.tags.isEmpty {
                        ProgramTagsView(tags: program.tags)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationTitle(program.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button(action: toggleSave) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .foregroundColor(.blue)
            }
        )
        .onAppear {
            checkIfSaved()
        }
        .alert("Zaloguj się", isPresented: $showingLoginAlert) {
            Button("Anuluj", role: .cancel) { }
            Button("Zaloguj") {
                showingProfile = true
            }
        } message: {
            Text("Musisz się zalogować, aby zapisywać programy studiów.")
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
    
    private func checkIfSaved() {
        if let user = firebaseService.currentUser {
            isSaved = user.savedPrograms.contains(program.id)
        }
    }
    
    private func toggleSave() {
        // Check if user is authenticated
        guard firebaseService.isAuthenticated else {
            showingLoginAlert = true
            return
        }
        
        Task {
            do {
                if isSaved {
                    try await firebaseService.unsaveProgram(programId: program.id)
                } else {
                    try await firebaseService.saveProgram(programId: program.id)
                }
                isSaved.toggle()
            } catch {
                print("Error toggling save: \(error)")
            }
        }
    }
}

struct ProgramHeroView: View {
    let program: StudyProgram
    let university: University
    @State private var imageLoadFailed = false
    @Environment(\.dismiss) private var dismiss
    let isSaved: Bool
    let toggleSave: () -> Void
    
    private var backgroundGradient: LinearGradient {
        let colors: [Color] = [.blue, .purple, .green, .orange, .pink].shuffled()
        return LinearGradient(
            gradient: Gradient(colors: [colors[0].opacity(0.8), colors[1].opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Background - either image or gradient
                if let imageURL = program.thumbnailURL ?? program.imageURL,
                   !imageLoadFailed,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .overlay(
                                    // Enhanced gradient overlay for better text readability
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.black.opacity(0),
                                            Color.black.opacity(0.1),
                                            Color.black.opacity(0.2),
                                            Color.black.opacity(0.4),
                                            Color.black.opacity(0.6),
                                            Color.black.opacity(0.8),
                                            Color.black.opacity(0.9)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        case .failure(_):
                            backgroundGradient
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .onAppear { imageLoadFailed = true }
                        case .empty:
                            ZStack {
                                Color.secondary.opacity(0.1)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        @unknown default:
                            backgroundGradient
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                } else {
                    backgroundGradient
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                // Content overlay
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(program.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        HStack(spacing: 8) {
                            if let shortName = university.shortName {
                                Text(shortName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            
                            if let faculty = program.faculty {
                                Text("•")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(faculty)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineLimit(1)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.top, 60) // Add top padding to move content down
                    .padding(.bottom, 100) // Increased to make room for essential info
                }
            }
            
            // Bottom gradient for smooth transition
            VStack {
                Spacer()
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.clear, location: 0),
                        .init(color: Color(.systemBackground).opacity(0.05), location: 0.1),
                        .init(color: Color(.systemBackground).opacity(0.1), location: 0.2),
                        .init(color: Color(.systemBackground).opacity(0.2), location: 0.3),
                        .init(color: Color(.systemBackground).opacity(0.35), location: 0.4),
                        .init(color: Color(.systemBackground).opacity(0.5), location: 0.5),
                        .init(color: Color(.systemBackground).opacity(0.65), location: 0.6),
                        .init(color: Color(.systemBackground).opacity(0.8), location: 0.7),
                        .init(color: Color(.systemBackground).opacity(0.9), location: 0.85),
                        .init(color: Color(.systemBackground), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 280)
            }
        }
        .frame(height: 400)
    }
}

struct ProgramEssentialsView: View {
    let program: StudyProgram
    
    var body: some View {
        // Essential Info Grid only
        HStack(spacing: 0) {
            EssentialInfoCell(
                label: "Stopień",
                value: program.degree.rawValue
            )
            
            Divider()
                .frame(height: 50)
            
            EssentialInfoCell(
                label: "Tryb",
                value: program.mode.rawValue
            )
            
            Divider()
                .frame(height: 50)
            
            EssentialInfoCell(
                label: "Czas trwania",
                value: "\(program.durationSemesters) sem."
            )
            
            if let tuition = program.tuitionFee, tuition > 0 {
                Divider()
                    .frame(height: 50)
                
                EssentialInfoCell(
                    label: "Czesne",
                    value: "\(tuition) zł/sem"
                )
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EssentialInfoCell: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.body, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

struct AdmissionProgressView: View {
    let threshold: Double
    let applicationURL: String?
    let program: StudyProgram
    @StateObject private var firebaseService = FirebaseService.shared
    @StateObject private var localStorage = LocalStorageService.shared
    
    // Calculate user's progress based on their matura scores
    private var userProgress: Double? {
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
    
    private var userPoints: Double {
        if let progress = userProgress {
            return progress * threshold
        }
        return 0
    }
    
    private var progress: Double {
        userProgress ?? 0
    }
    
    private var progressColor: Color {
        if let userProgress = userProgress {
            if userProgress >= 1.0 {
                return .green
            } else if userProgress >= 0.8 {
                return .orange
            } else {
                return .red
            }
        }
        return .secondary
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Twoje szanse")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        if userProgress != nil {
                            Text("\(Int(userPoints))")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(progressColor)
                            + Text(" / \(Int(threshold)) pkt")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.secondary)
                                    .frame(width: 10, height: 10)
                                Text("Wprowadź maturę")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Spacer()
                
                if let url = applicationURL, let applicationURL = URL(string: url) {
                    Link(destination: applicationURL) {
                        HStack(spacing: 6) {
                            Text("Aplikuj teraz")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            // Progress Bar
            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        // Progress fill
                        Rectangle()
                            .fill(progressColor)
                            .frame(width: geometry.size.width * min(progress, 1.0), height: 8)
                            .cornerRadius(4)
                            .animation(.easeInOut(duration: 0.5), value: progress)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, 16)
                
                // Progress text
                HStack {
                    Text(progressText)
                        .font(.caption)
                        .foregroundColor(progressColor)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    if let userProgress = userProgress {
                        if userProgress > 1.0 {
                            Text("+\(Int((userProgress - 1.0) * 100))%")
                                .font(.caption)
                                .foregroundColor(progressColor)
                                .fontWeight(.medium)
                        } else {
                            Text("\(Int(userProgress * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private var progressText: String {
        if userProgress == nil {
            return "Brak danych o maturze"
        } else if progress >= 1.0 {
            return "Wysokie szanse"
        } else if progress >= 0.8 {
            return "Umiarkowane szanse"
        } else {
            return "Niskie szanse"
        }
    }
}

struct ProgramDescriptionView: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(description)
                .font(.body)
                .lineSpacing(4)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
        }
    }
}

struct ProgramAdmissionView: View {
    let program: StudyProgram
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Rekrutacja")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Description if available
            if let description = program.requirements.description {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Zasady rekrutacji")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Formula - with LaTeX-like display
            if let formula = program.requirements.formula {
                ProgramFormulaCard(formula: formula.metadata.description)
                
                // Formula Legend
                FormulaLegendView()
                    .padding(.top, 8)
            }
            
            // Additional exams - only if present
            if !program.requirements.additionalExams.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dodatkowe egzaminy")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(program.requirements.additionalExams.joined(separator: ", "))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            
            // Deadline - simple format
            if let deadline = program.requirements.deadlineDate {
                HStack {
                    Text("Termin:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(deadline, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
    }
}


struct ProgramTagsView: View {
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tematyka")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            // Simple wrapping for iOS 15 - split into rows
            VStack(alignment: .leading, spacing: 8) {
                let chunkedTags = tags.chunked(into: 3) // Split into groups of 3
                ForEach(Array(chunkedTags.enumerated()), id: \.offset) { index, tagGroup in
                    HStack(spacing: 8) {
                        ForEach(tagGroup, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.tertiarySystemBackground))
                                .foregroundColor(.secondary)
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct NoThresholdInfoView: View {
    let applicationURL: String?
    let program: StudyProgram
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Info header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: iconForAdmissionType)
                        .font(.subheadline)
                        .foregroundColor(colorForAdmissionType)
                    
                    Text(titleForAdmissionType)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                if let url = applicationURL, let applicationURL = URL(string: url) {
                    Link(destination: applicationURL) {
                        HStack(spacing: 6) {
                            Text("Aplikuj teraz")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(20)
                    }
                }
            }
            
            // Explanation based on admission type
            Text(explanationForAdmissionType)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
            
            // Show entrance exam details if available
            if program.requirements.admissionType == .entranceExam || 
               program.requirements.admissionType == .mixed ||
               program.requirements.admissionType == .portfolio,
               let examDetails = program.requirements.entranceExamDetails {
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Proces rekrutacji:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    ForEach(Array(examDetails.stages.enumerated()), id: \.offset) { index, stage in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1).")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                                .frame(width: 20, alignment: .leading)
                            
                            Text(stage)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    if let tips = examDetails.preparationTips {
                        Text("Wskazówki:")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .padding(.top, 4)
                        
                        Text(tips)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    
                    if let sampleURL = examDetails.sampleTasksURL,
                       let url = URL(string: sampleURL) {
                        Link(destination: url) {
                            HStack(spacing: 4) {
                                Image(systemName: "doc.text")
                                    .font(.caption)
                                Text("Przykładowe zadania")
                                    .font(.caption)
                                    .underline()
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.top, 8)
                .padding(12)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(8)
            } else {
                // Alternative helpful info for unknown or missing data
                VStack(alignment: .leading, spacing: 8) {
                    Text("Co możesz zrobić:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "1.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("Sprawdź wyniki rekrutacji z poprzednich lat na stronie uczelni")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "2.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("Skontaktuj się z biurem rekrutacji uczelni")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "3.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("Porównaj z podobnymi kierunkami na tej uczelni")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(colorForAdmissionType.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
    
    private var iconForAdmissionType: String {
        switch program.requirements.admissionType {
        case .entranceExam:
            return "pencil.and.list.clipboard"
        case .portfolio:
            return "photo.stack"
        case .mixed:
            return "square.split.2x1"
        case .interview:
            return "person.2.wave.2"
        case .unknown:
            return "questionmark.circle"
        case .maturaPoints:
            return "info.circle"
        }
    }
    
    private var colorForAdmissionType: Color {
        switch program.requirements.admissionType {
        case .entranceExam:
            return .purple
        case .portfolio:
            return .indigo
        case .mixed:
            return .blue
        case .interview:
            return .green
        case .unknown:
            return .secondary
        case .maturaPoints:
            return .orange
        }
    }
    
    private var titleForAdmissionType: String {
        switch program.requirements.admissionType {
        case .entranceExam:
            return "Wymagany egzamin wstępny"
        case .portfolio:
            return "Rekrutacja na podstawie portfolio"
        case .mixed:
            return "Matura + egzamin wstępny"
        case .interview:
            return "Rozmowa kwalifikacyjna"
        case .unknown:
            return "Brak danych o rekrutacji"
        case .maturaPoints:
            return "Brak danych o progu punktowym"
        }
    }
    
    private var explanationForAdmissionType: String {
        switch program.requirements.admissionType {
        case .entranceExam:
            return "Ten kierunek wymaga zdania egzaminu wstępnego. Punkty maturalne nie są brane pod uwagę lub stanowią tylko część oceny końcowej."
        case .portfolio:
            return "Rekrutacja opiera się na ocenie portfolio oraz umiejętności artystycznych kandydata. Przygotuj swoje najlepsze prace."
        case .mixed:
            return "Rekrutacja dwuetapowa: najpierw weryfikacja punktów maturalnych, następnie egzamin wstępny lub ocena portfolio."
        case .interview:
            return "Kwalifikacja odbywa się na podstawie rozmowy z komisją rekrutacyjną. Przygotuj się na pytania o motywację i doświadczenie."
        case .unknown:
            return "Szczegółowe kryteria rekrutacji nie zostały jeszcze opublikowane. Prosimy o regularne sprawdzanie strony uczelni."
        case .maturaPoints:
            return "Próg punktowy dla tego kierunku nie jest jeszcze dostępny. Sprawdź informacje na stronie uczelni."
        }
    }
}

// MARK: - Formula Legend
struct FormulaLegendView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Legenda")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                LegendRow(
                    symbol: "R",
                    description: "Poziom rozszerzony",
                    color: .blue
                )
                
                LegendRow(
                    symbol: "P",
                    description: "Poziom podstawowy",
                    color: .green
                )
                
                LegendRow(
                    symbol: "×",
                    description: "Współczynnik wagowy",
                    color: .orange
                )
                
                LegendRow(
                    symbol: "max()",
                    description: "Najwyższy wynik z podanych przedmiotów",
                    color: .purple
                )
                
                LegendRow(
                    symbol: "W",
                    description: "Wynik końcowy (punkty rekrutacyjne)",
                    color: .red
                )
            }
            
            Divider()
                .padding(.vertical, 8)
            
            Text("Skróty przedmiotów")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    SubjectAbbreviationRow(abbr: "mat", full: "matematyka")
                    SubjectAbbreviationRow(abbr: "pol", full: "język polski")
                    SubjectAbbreviationRow(abbr: "ang", full: "język angielski")
                }
                HStack(spacing: 16) {
                    SubjectAbbreviationRow(abbr: "inf", full: "informatyka")
                    SubjectAbbreviationRow(abbr: "fiz", full: "fizyka")
                    SubjectAbbreviationRow(abbr: "chem", full: "chemia")
                }
                HStack(spacing: 16) {
                    SubjectAbbreviationRow(abbr: "bio", full: "biologia")
                    SubjectAbbreviationRow(abbr: "hist", full: "historia")
                    SubjectAbbreviationRow(abbr: "geo", full: "geografia")
                }
                HStack(spacing: 16) {
                    SubjectAbbreviationRow(abbr: "WOS", full: "wiedza o społ.")
                    SubjectAbbreviationRow(abbr: "j.ob", full: "język obcy")
                    Spacer()
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.quaternarySystemFill), lineWidth: 1)
                )
        )
    }
}

struct LegendRow: View {
    let symbol: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Symbol badge
            Text(symbol)
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundColor(color)
                .frame(width: 40, alignment: .center)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                )
            
            // Description
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SubjectAbbreviationRow: View {
    let abbr: String
    let full: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(abbr)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(.primary)
                .frame(minWidth: 35, alignment: .trailing)
            
            Text("=")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            
            Text(full)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(minWidth: 100, alignment: .leading)
    }
}

// MARK: - Program Formula Card
struct ProgramFormulaCard: View {
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
                ProgramFormulaView(formula: formula)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.vertical, 4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Program Formula View
struct ProgramFormulaView: View {
    let formula: String
    @State private var parsedFormula: [FormulaElement] = []
    
    var body: some View {
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
            
            switch element {
            case .coefficient, .subject, .maxFunction:
                elementCount += 1
            case .mathOperator:
                break
            }
            
            if case .mathOperator(let op) = element, op == "+", elementCount >= 3 {
                lines.append(currentLine)
                currentLine = []
                elementCount = 0
            }
        }
        
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }
        
        return lines.isEmpty ? [parsedFormula] : lines
    }
    
    private func parseFormula(_ formula: String) -> [FormulaElement] {
        var components: [FormulaElement] = []
        let cleanFormula = formula.replacingOccurrences(of: "W = ", with: "")
                                .replacingOccurrences(of: "W=", with: "")
        
        let pattern = "([+\\-×*/])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = cleanFormula as NSString
        let matches = regex?.matches(in: cleanFormula, options: [], range: NSRange(location: 0, length: nsString.length)) ?? []
        
        var lastEnd = 0
        
        for match in matches {
            let range = match.range
            
            if range.location > lastEnd {
                let beforeRange = NSRange(location: lastEnd, length: range.location - lastEnd)
                let beforeText = nsString.substring(with: beforeRange).trimmingCharacters(in: .whitespaces)
                if !beforeText.isEmpty {
                    components.append(contentsOf: parseComponent(beforeText))
                }
            }
            
            let operatorText = nsString.substring(with: range)
            components.append(.mathOperator(operatorText))
            
            lastEnd = range.location + range.length
        }
        
        if lastEnd < nsString.length {
            let remainingText = nsString.substring(from: lastEnd).trimmingCharacters(in: .whitespaces)
            if !remainingText.isEmpty {
                components.append(contentsOf: parseComponent(remainingText))
            }
        }
        
        if components.isEmpty {
            components = parseComponent(cleanFormula)
        }
        
        return components
    }
    
    private func parseComponent(_ text: String) -> [FormulaElement] {
        var components: [FormulaElement] = []
        
        if text.contains("×") || text.contains("*") {
            let parts = text.split(separator: text.contains("×") ? "×" : "*").map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                if let coefficient = Double(parts[0]) {
                    components.append(.coefficient(coefficient))
                    components.append(.mathOperator("×"))
                }
                components.append(.subject(formatSubject(parts[1])))
                return components
            }
        }
        
        if text.hasPrefix("max(") {
            // Check if there's a level indicator after the closing parenthesis
            var level = ""
            var maxContent = text
            
            if text.hasSuffix(") (R)") {
                level = "R"
                maxContent = String(text.dropLast(4)) // Remove " (R)"
            } else if text.hasSuffix(")(R)") {
                level = "R"
                maxContent = String(text.dropLast(3)) // Remove "(R)"
            } else if text.hasSuffix(") (P)") {
                level = "P"
                maxContent = String(text.dropLast(4)) // Remove " (P)"
            } else if text.hasSuffix(")(P)") {
                level = "P"
                maxContent = String(text.dropLast(3)) // Remove "(P)"
            }
            
            if maxContent.hasSuffix(")") {
                let content = String(maxContent.dropFirst(4).dropLast(1))
                let subjects = content.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                
                // If level was found after max(), apply it to all subjects
                if !level.isEmpty {
                    components.append(.maxFunction(subjects.map { (name: formatSubject($0).name, level: level) }))
                } else {
                    components.append(.maxFunction(subjects.map { formatSubject($0) }))
                }
                return components
            }
        }
        
        if let number = Double(text) {
            components.append(.coefficient(number))
            return components
        }
        
        components.append(.subject(formatSubject(text)))
        return components
    }
    
    private func formatSubject(_ subject: String) -> (name: String, level: String) {
        var cleanSubject = subject
        var level = ""
        
        // Debug print
        print("Formatting subject: '\(subject)'")
        
        // Extract level from parentheses - handle all cases
        if subject.contains("(R)") || subject.contains(" (R)") || subject.contains("( R )") {
            level = "R"
            cleanSubject = subject
                .replacingOccurrences(of: " ( R )", with: "")
                .replacingOccurrences(of: "( R )", with: "")
                .replacingOccurrences(of: " (R)", with: "")
                .replacingOccurrences(of: "(R)", with: "")
                .trimmingCharacters(in: .whitespaces)
        } else if subject.contains("(P)") || subject.contains(" (P)") || subject.contains("( P )") {
            level = "P"
            cleanSubject = subject
                .replacingOccurrences(of: " ( P )", with: "")
                .replacingOccurrences(of: "( P )", with: "")
                .replacingOccurrences(of: " (P)", with: "")
                .replacingOccurrences(of: "(P)", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        
        let subjectMap: [String: String] = [
            "matematyka": "mat",
            "fizyka": "fiz",
            "chemia": "chem",
            "informatyka": "inf",
            "biologia": "bio",
            "język polski": "pol",
            "j. polski": "pol",
            "język angielski": "ang",
            "j. angielski": "ang",
            "język obcy": "j.ob",
            "j. obcy": "j.ob",
            "geografia": "geo",
            "historia": "hist",
            "wos": "WOS",
            "wiedza o społeczeństwie": "WOS"
        ]
        
        if let mappedName = subjectMap[cleanSubject.lowercased()] {
            cleanSubject = mappedName
        }
        
        return (name: cleanSubject, level: level)
    }
    
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
                        if !info.level.isEmpty {
                            Text(info.level)
                                .font(.system(size: 8, weight: .medium))
                                .baselineOffset(7)
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
                        Text("(")
                            .font(.system(size: 16))
                        ForEach(subjects.indices, id: \.self) { index in
                            HStack(spacing: 0) {
                                Text(subjects[index].name)
                                    .font(.system(size: 14))
                                if !subjects[index].level.isEmpty {
                                    Text(subjects[index].level)
                                        .font(.system(size: 7, weight: .medium))
                                        .baselineOffset(6)
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
}

#Preview {
    NavigationView {
        ProgramDetailView(
            program: MockDataService.shared.mockPrograms.first!,
            university: MockDataService.shared.mockUniversities.first!
        )
    }
}