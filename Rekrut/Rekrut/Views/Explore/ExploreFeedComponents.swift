//
//  ExploreFeedComponents.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct EmptyFilterResultsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("Brak wyników")
                .font(.headline)
            
            Text("Spróbuj zmienić filtry, aby zobaczyć więcej kierunków")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}

struct TrendingProgramCard: View {
    let program: StudyProgram
    let university: University?
    @State private var imageLoadFailed = false
    @State private var showingDetail = false
    @StateObject private var firebaseService = FirebaseService.shared
    @StateObject private var localStorage = LocalStorageService.shared
    
    private var isSaved: Bool {
        firebaseService.currentUser?.savedPrograms.contains(program.id) ?? false
    }
    
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
        
        // Use the program's extension method for proper formula-based calculation
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
    
    
    private var backgroundGradient: LinearGradient {
        let colors: [Color] = [.blue, .purple, .green, .orange, .pink].shuffled()
        return LinearGradient(
            gradient: Gradient(colors: [colors[0].opacity(0.8), colors[1].opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
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
                                .frame(width: 280, height: 180)
                                .clipped()
                                .overlay(
                                    // Enhanced gradient overlay for better text readability
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.black.opacity(0),
                                            Color.black.opacity(0.3),
                                            Color.black.opacity(0.8)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        case .failure(_):
                            backgroundGradient
                                .onAppear { imageLoadFailed = true }
                        case .empty:
                            // Loading state
                            ZStack {
                                Color.secondary.opacity(0.1)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                            }
                        @unknown default:
                            backgroundGradient
                        }
                    }
                } else {
                    // Fallback gradient when no image URL
                    backgroundGradient
                }
                
                // Content overlay
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    // Degree type in small text above title
                    Text(program.degree.rawValue)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                        .textCase(.uppercase)
                    
                    Text(program.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text(university?.shortName ?? "")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        
                        if let faculty = program.faculty {
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(faculty)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(1)
                        }
                    }
                }
                .padding()
            }
            .frame(width: 280, height: 180)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            .overlay(
                // Pills and bookmark in top right
                HStack(spacing: 8) {
                    // Bookmark indicator
                    if isSaved {
                        Image(systemName: "bookmark.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }
                    
                    // Score indicator with progress
                    if let threshold = program.lastYearThreshold {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(getProgressColor())
                                .frame(width: 8, height: 8)
                            
                            // Show +X% if user is above threshold, otherwise show appropriate text
                            if let progress = userProgress {
                                if progress > 1.0 {
                                    Text("+\(Int((progress - 1.0) * 100))%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                } else {
                                    Text("\(Int(progress * 100))%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(getProgressColor())
                                }
                            } else {
                                // User hasn't entered matura scores
                                Text("Wprowadź maturę")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemBackground).opacity(0.9))
                        .cornerRadius(12)
                    } else {
                        // Show admission type for programs without threshold
                        HStack(spacing: 4) {
                            Image(systemName: getAdmissionTypeIcon())
                                .font(.caption2)
                            Text(getAdmissionTypeText())
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(getAdmissionTypeColor().opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.top, 12)
                .padding(.trailing, 12),
                alignment: .topTrailing
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                ProgramDetailView(program: program, university: university ?? MockDataService.shared.mockUniversities.first!)
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
    
    private func getIconForField(_ field: String) -> String {
        if field.contains("Informatyka") { return "laptopcomputer" }
        if field.contains("Medycyna") { return "cross.case.fill" }
        if field.contains("Prawo") { return "scale.3d" }
        if field.contains("Ekonomia") { return "chart.line.uptrend.xyaxis" }
        return "book.fill"
    }
    
    private func getAdmissionChanceColor(threshold: Double) -> Color {
        // Based on Rekrut Score (0-100 proprietary system)
        if threshold >= 85 {
            return .red // Highly competitive (<40% admission chance)
        } else if threshold >= 70 {
            return .yellow // Moderate competition (40-70% admission chance)
        } else {
            return .green // Good chances (>70% admission chance)
        }
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
        // Secondary color if no user data entered
        return .secondary
    }
    
    private func getAdmissionTypeIcon() -> String {
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
    
    private func getAdmissionTypeText() -> String {
        switch program.requirements.admissionType {
        case .entranceExam:
            return "Egzamin"
        case .portfolio:
            return "Portfolio"
        case .mixed:
            return "Matura+Egzamin"
        case .interview:
            return "Rozmowa"
        case .unknown:
            return "Brak danych"
        case .maturaPoints:
            return "Brak progu"
        }
    }
    
    private func getAdmissionTypeColor() -> Color {
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
}

struct RecommendedProgramCard: View {
    let program: StudyProgram
    let university: University?
    @State private var showingDetail = false
    @StateObject private var firebaseService = FirebaseService.shared
    @StateObject private var localStorage = LocalStorageService.shared
    
    private var isSaved: Bool {
        firebaseService.currentUser?.savedPrograms.contains(program.id) ?? false
    }
    
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
        
        // Use the program's extension method for proper formula-based calculation
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
    
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    // Degree type in small text above title
                    Text(program.degree.rawValue)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(program.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(university?.displayName ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        if let slots = program.availableSlots {
                            Label("\(slots) miejsc", systemImage: "person.3.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        if let threshold = program.lastYearThreshold {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(getProgressColor())
                                    .frame(width: 6, height: 6)
                                
                                // Show +X% if user is above threshold
                                if let progress = userProgress, progress > 1.0 {
                                    Text("+\(Int((progress - 1.0) * 100))%")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                } else if userProgress == nil {
                                    // User hasn't entered matura scores
                                    Text("Wprowadź maturę")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("\(Int(threshold)) pkt")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        } else {
                            // Show admission type
                            Label(getAdmissionTypeShortText(), systemImage: getAdmissionTypeIcon())
                                .font(.caption)
                                .foregroundColor(getAdmissionTypeColor())
                        }
                    }
                }
                
                Spacer()
                
                if isSaved {
                    Image(systemName: "bookmark.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.trailing, 4)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 10)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                ProgramDetailView(program: program, university: university ?? MockDataService.shared.mockUniversities.first!)
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
        // Secondary color if no user data entered
        return .secondary
    }
    
    private func getAdmissionTypeIcon() -> String {
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
    
    private func getAdmissionTypeShortText() -> String {
        switch program.requirements.admissionType {
        case .entranceExam:
            return "Egzamin"
        case .portfolio:
            return "Portfolio"
        case .mixed:
            return "Matura+Egzamin"
        case .interview:
            return "Rozmowa"
        case .unknown:
            return "Brak danych"
        case .maturaPoints:
            return "Brak progu"
        }
    }
    
    private func getAdmissionTypeColor() -> Color {
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
}

struct CategoryGridView: View {
    private let mockData = MockDataService.shared
    
    private var categoriesWithCounts: [(name: String, icon: String, color: Color, count: Int)] {
        let allPrograms = mockData.mockPrograms
        
        let categories: [(String, String, Color, [String])] = [
            ("Informatyka i IT", "laptopcomputer", Color.blue, ["Informatyka", "Cyberbezpieczeństwo", "Data Science", "Sztuczna inteligencja", "Informatyka stosowana"]),
            ("Medycyna i Zdrowie", "cross.case.fill", Color.red, ["Medycyna", "Farmacja", "Fizjoterapia", "Pielęgniarstwo", "Stomatologia", "Ratownictwo medyczne", "Zdrowie publiczne"]),
            ("Biznes i Ekonomia", "chart.line.uptrend.xyaxis", Color.green, ["Ekonomia", "Zarządzanie", "Finanse", "Marketing", "Logistyka", "E-business", "Międzynarodowe stosunki gospodarcze"]),
            ("Prawo i Administracja", "scale.3d", Color.orange, ["Prawo", "Administracja", "Administracja publiczna", "Bezpieczeństwo wewnętrzne", "Kryminologia", "Stosunki międzynarodowe"]),
            ("Inżynieria i Technika", "gearshape.fill", Color.purple, ["Inżynieria", "Automatyka", "Robotyka", "Mechanika", "Elektronika", "Budownictwo", "Architektura", "Lotnictwo", "Inżynieria środowiska", "Energetyka"]),
            ("Humanistyka i Języki", "book.fill", Color.pink, ["Filologia", "Historia", "Filozofia", "Kulturoznawstwo", "Lingwistyka", "Przekład", "Dziennikarstwo", "Komunikacja społeczna"]),
            ("Sztuka i Design", "paintbrush.fill", Color.indigo, ["Sztuka", "Grafika", "Design", "Wzornictwo", "Architektura wnętrz", "Fotografia", "Film", "Muzyka", "Teatr", "Konserwacja dzieł sztuki", "Animacja"]),
            ("Sport i Turystyka", "figure.run", Color.mint, ["Wychowanie fizyczne", "Sport", "Turystyka", "Rekreacja", "Dietetyka sportowa", "Fizjoterapia sportowa", "Zarządzanie sportem"]),
            ("Nauki społeczne", "person.3.fill", Color.teal, ["Psychologia", "Socjologia", "Pedagogika", "Praca socjalna", "Politologia", "Nauki o rodzinie", "Resocjalizacja", "Teologia", "Stosunki międzynarodowe"]),
            ("Rolnictwo i Środowisko", "leaf.fill", Color(red: 0.2, green: 0.6, blue: 0.2), ["Rolnictwo", "Leśnictwo", "Ochrona środowiska", "Biologia", "Biotechnologia", "Weterynaria", "Ogrodnictwo", "Zootechnika", "Gastronomia"])
        ]
        
        return categories.map { category in
            let count = allPrograms.filter { program in
                category.3.contains { field in
                    program.field.lowercased().contains(field.lowercased()) ||
                    program.name.lowercased().contains(field.lowercased())
                }
            }.count
            
            return (name: category.0, icon: category.1, color: category.2, count: count)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(categoriesWithCounts.enumerated()), id: \.element.name) { index, category in
                NavigationLink(destination: CategoryProgramsView(
                    categoryName: category.name,
                    categoryIcon: category.icon,
                    categoryColor: category.color
                )) {
                    CategoryListRow(
                        title: category.name,
                        icon: category.icon,
                        color: category.color,
                        programCount: category.count
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                if index < categoriesWithCounts.count - 1 {
                    Divider()
                        .padding(.leading, 72)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct CategoryListRow: View {
    let title: String
    let icon: String
    let color: Color
    let programCount: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with colored background
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("\(programCount) kierunków")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

struct UniversityCompactCard: View {
    let university: University
    @State private var logoLoadFailed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // University logo or ranking badge
            if let logoURL = university.logoURL,
               !logoLoadFailed,
               let url = URL(string: logoURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                    case .failure(_):
                        rankingBadge
                            .onAppear { logoLoadFailed = true }
                    case .empty:
                        ProgressView()
                            .frame(width: 50, height: 50)
                    @unknown default:
                        rankingBadge
                    }
                }
            } else {
                rankingBadge
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(university.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label(university.city, systemImage: "mappin")
                    Label(university.type.rawValue, systemImage: "building.2")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    @ViewBuilder
    private var rankingBadge: some View {
        if let ranking = university.ranking {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                VStack(spacing: 2) {
                    Text("#\(ranking)")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Text("miejsce")
                        .font(.system(size: 9))
                        .foregroundColor(.orange.opacity(0.8))
                }
            }
        } else {
            Circle()
                .fill(Color.secondary.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(university.shortName ?? String(university.name.prefix(2)))
                        .font(.headline)
                        .foregroundColor(.secondary)
                )
        }
    }
}

struct MinimalistUniversityCardWithSheet: View {
    let university: University
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            MinimalistUniversityCard(university: university)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                UniversityDetailView(university: university)
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
}

struct MinimalistUniversityCard: View {
    let university: University
    @State private var imageLoadFailed = false
    
    private var backgroundGradient: LinearGradient {
        let colors: [Color] = [.blue, .purple, .green, .orange, .indigo].shuffled()
        return LinearGradient(
            gradient: Gradient(colors: [colors[0].opacity(0.7), colors[1].opacity(0.5)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image or gradient
            if let imageURL = university.imageURL,
               !imageLoadFailed,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 140, height: 140)
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
                    case .failure(_):
                        backgroundGradient
                            .onAppear { imageLoadFailed = true }
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.1)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        }
                    @unknown default:
                        backgroundGradient
                    }
                }
            } else {
                backgroundGradient
            }
            
            // Content overlay
            VStack(alignment: .leading, spacing: 4) {
                Text(university.shortName ?? university.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(university.city)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.bottom, 12)
            .padding(.leading, 12)
        }
        .frame(width: 140, height: 140)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CityInfo: Identifiable {
    let id = UUID()
    let name: String
    let universityCount: Int
    let imageURL: String?
    let color: Color
}

struct ExploreCityCard: View {
    let city: CityInfo
    @State private var imageLoadFailed = false
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [city.color.opacity(0.8), city.color.opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background - either image or gradient
            if let imageURL = city.imageURL,
               let url = URL(string: imageURL),
               !imageLoadFailed {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 140)
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
                    case .failure(_):
                        backgroundGradient
                            .onAppear { imageLoadFailed = true }
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.1)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        }
                    @unknown default:
                        backgroundGradient
                    }
                }
            } else {
                backgroundGradient
            }
            
            // Content overlay
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                
                Text(city.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "building.2")
                        .font(.caption)
                    Text("\(city.universityCount) uczelni")
                        .font(.caption)
                }
                .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
        .frame(width: 200, height: 140)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ExploreSectionHeader: View {
    let title: String
    let icon: String
    let actionText: String?
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
            
            if let actionText = actionText {
                Button(action: action) {
                    Text(actionText)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
    }
}
