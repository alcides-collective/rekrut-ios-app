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
                        // Combined profile and insights sections
                        VStack(alignment: .leading, spacing: 24) {
                            // AI Message panel
                            AIMessagePanel(
                                message: generatePersonalizedMessage(answers: answers, programs: matchedPrograms)
                            )
                            .padding(.horizontal, 24)
                            
                            // Pinterest-style staggered grid with dynamic sorting
                            PinterestGrid(
                                insightCards: [
                                    GridInsightCard(
                                        title: "Twój profil akademicki",
                                        description: generateAcademicProfile(answers: answers, programs: matchedPrograms),
                                        color: .purple
                                    ),
                                    GridInsightCard(
                                        title: "Perspektywy zawodowe",
                                        description: generateCareerProspects(programs: matchedPrograms),
                                        color: .orange
                                    ),
                                    GridInsightCard(
                                        title: "Dopasowanie społeczne",
                                        description: generateSocialFit(answers: answers),
                                        color: .blue
                                    ),
                                    GridInsightCard(
                                        title: "Szanse rekrutacyjne",
                                        description: generateAdmissionChances(programs: matchedPrograms),
                                        color: .green
                                    ),
                                    GridInsightCard(
                                        title: "Idealny kampus",
                                        description: generateCampusPreferences(answers: answers, programs: matchedPrograms),
                                        color: .teal
                                    ),
                                    GridInsightCard(
                                        title: "Unikalne możliwości",
                                        description: generateUniqueOpportunities(programs: matchedPrograms),
                                        color: .indigo
                                    )
                                ],
                                programCards: Array(matchedPrograms.prefix(10).enumerated()).map { index, match in
                                    ProgramGridCard(
                                        program: match.program,
                                        university: MockDataService.shared.mockUniversities.first { $0.id == match.program.universityId }!,
                                        score: match.score,
                                        rank: index + 1,
                                        reasons: match.reasons,
                                        whyRecommended: generateWhyRecommended(for: match.program, answers: answers, score: match.score)
                                    )
                                }
                            )
                            .padding(.horizontal, 24)
                        }
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

// Helper functions for generating insights
private func generateAcademicProfile(answers: [String: Any], programs: [(program: StudyProgram, score: Int, reasons: [String])]) -> String {
    var profile = ""
    
    if let subjects = answers["subjects"] as? Set<String> {
        if subjects.contains("Matematyka i fizyka") {
            profile = "Typ analityczny z mocnym zapleczem w naukach ścisłych. "
        } else if subjects.contains("Języki i historia") {
            profile = "Typ humanistyczny z talentem językowym. "
        } else if subjects.contains("Biologia i chemia") {
            profile = "Typ badawczy z zamiłowaniem do nauk przyrodniczych. "
        }
    }
    
    // Add learning style insight
    if let skills = answers["skills"] as? [String: Double],
       let creativity = skills["Kreatywność"],
       creativity > 3.5 {
        profile += "Preferujesz projekty i praktyczne zadania."
    } else {
        profile += "Cenisz systematyczną naukę i teorię."
    }
    
    return profile.isEmpty ? "Wszechstronny profil z potencjałem w wielu dziedzinach" : profile
}

private func generateCareerProspects(programs: [(program: StudyProgram, score: Int, reasons: [String])]) -> String {
    // Get top 3 matched programs and their career fields
    let topPrograms = programs.prefix(3)
    var careerFields = Set<String>()
    
    for match in topPrograms {
        if match.program.field.contains("Informatyka") {
            careerFields.insert("IT i programowanie")
        } else if match.program.field.contains("Medycyna") {
            careerFields.insert("ochrona zdrowia")
        } else if match.program.field.contains("Prawo") {
            careerFields.insert("prawo i administracja")
        } else if match.program.field.contains("Ekonomia") {
            careerFields.insert("finanse i biznes")
        } else if match.program.field.contains("Inżynieria") {
            careerFields.insert("przemysł i technologie")
        }
    }
    
    if careerFields.isEmpty {
        return "Szerokie możliwości rozwoju w różnych branżach"
    } else {
        return "Najlepsze perspektywy w: \(careerFields.joined(separator: ", ")). Średnie zarobki po 5 latach: 8-15 tys. PLN"
    }
}

private func generateSocialFit(answers: [String: Any]) -> String {
    var socialProfile = ""
    
    if let priorities = answers["priorities"] as? Set<String> {
        if priorities.contains("Życie studenckie") {
            socialProfile = "Aktywny społecznie - koła naukowe, organizacje studenckie będą idealne. "
        } else if priorities.contains("Prestiż uczelni") {
            socialProfile = "Ambitny i zorientowany na sukces - networking akademicki będzie kluczowy. "
        }
    }
    
    if let location = answers["location"] as? String {
        if location.contains("dużym mieście") {
            socialProfile += "Środowisko wielkomiejskie z bogatą ofertą kulturalną."
        } else if location.contains("małym mieście") {
            socialProfile += "Kameralna atmosfera, łatwiejsze nawiązywanie znajomości."
        }
    }
    
    return socialProfile.isEmpty ? "Łatwo adaptujesz się do różnych środowisk społecznych" : socialProfile
}

private func generateAdmissionChances(programs: [(program: StudyProgram, score: Int, reasons: [String])]) -> String {
    let highChance = programs.filter { $0.score >= 85 }.count
    let mediumChance = programs.filter { $0.score >= 70 && $0.score < 85 }.count
    let lowChance = programs.filter { $0.score < 70 }.count
    
    var assessment = ""
    if highChance >= 5 {
        assessment = "Bardzo wysokie szanse! "
    } else if highChance >= 2 {
        assessment = "Dobre szanse na topowe kierunki. "
    } else {
        assessment = "Solidne szanse przyjęcia. "
    }
    
    assessment += "\(highChance) kierunków z >85% dopasowania, \(mediumChance) z dobrymi szansami"
    
    return assessment
}

private func generateCampusPreferences(answers: [String: Any], programs: [(program: StudyProgram, score: Int, reasons: [String])]) -> String {
    var preferences = ""
    
    if let location = answers["location"] as? String {
        if location.contains("blisko domu") {
            preferences = "Preferujesz uczelnię w pobliżu - oszczędność na mieszkaniu. "
        } else if location.contains("za granicą") {
            preferences = "Marzysz o studiach międzynarodowych - sprawdź programy Erasmus+. "
        }
    }
    
    // Check university types in top matches
    let topUniversities = programs.prefix(5).compactMap { match in
        MockDataService.shared.mockUniversities.first { $0.id == match.program.universityId }
    }
    
    if topUniversities.contains(where: { $0.type == .technical }) {
        preferences += "Pasują Ci uczelnie techniczne z nowoczesnymi laboratoriami."
    } else if topUniversities.contains(where: { $0.type == .university }) {
        preferences += "Cenisz tradycję i prestiż klasycznych uniwersytetów."
    }
    
    return preferences.isEmpty ? "Otwartość na różne typy kampusów i lokalizacji" : preferences
}

private func generateUniqueOpportunities(programs: [(program: StudyProgram, score: Int, reasons: [String])]) -> String {
    var opportunities = Set<String>()
    
    // Check for special features in top programs
    for match in programs.prefix(5) {
        if match.program.language == "Angielski" {
            opportunities.insert("Studia w języku angielskim")
        }
        if match.program.tuitionFee == 0 {
            opportunities.insert("Studia bezpłatne")
        }
        if match.program.tags.contains(where: { $0.contains("AI") || $0.contains("Machine Learning") }) {
            opportunities.insert("Specjalizacja AI/ML")
        }
        if match.program.requirements.admissionType == .portfolio {
            opportunities.insert("Rozwój artystyczny")
        }
    }
    
    if opportunities.isEmpty {
        return "Wiele programów z możliwością wyjazdów zagranicznych i praktyk w top firmach"
    } else {
        return opportunities.prefix(3).joined(separator: ", ") + ". Sprawdź szczegóły każdego kierunku!"
    }
}

private func generatePersonalizedMessage(answers: [String: Any], programs: [(program: StudyProgram, score: Int, reasons: [String])]) -> String {
    // In a real app, this would call OpenAI API with the user's answers and matched programs
    // For now, generate a personalized message based on the data we have
    
    let topMatch = programs.first
    let highMatches = programs.filter { $0.score >= 80 }.count
    
    var message = "Na podstawie Twoich odpowiedzi widzę, że "
    
    // Add personality insights
    if let subjects = answers["subjects"] as? Set<String> {
        if subjects.contains("Matematyka i fizyka") {
            message += "masz silne predyspozycje do nauk ścisłych i analitycznego myślenia. "
        } else if subjects.contains("Języki i historia") {
            message += "świetnie radzisz sobie z komunikacją i analizą tekstów. "
        }
    }
    
    // Add match insights
    if let top = topMatch {
        message += "Kierunek \(top.program.name) idealnie pasuje do Twojego profilu z \(top.score)% dopasowaniem. "
    }
    
    // Add recommendation
    if highMatches > 5 {
        message += "Masz wiele świetnych opcji do wyboru - warto rozważyć praktyki lub dni otwarte na uczelniach, aby lepiej poznać atmosferę każdej z nich."
    } else if highMatches > 0 {
        message += "Znaleźliśmy kilka kierunków, które mogą być dla Ciebie idealne. Zastanów się, który najbardziej odpowiada Twoim długoterminowym celom."
    }
    
    return message
}

private func generateRecommendedMajors(answers: [String: Any], programs: [(program: StudyProgram, score: Int, reasons: [String])]) -> String {
    let topPrograms = programs.prefix(3)
    var majorsList = ""
    
    for (index, match) in topPrograms.enumerated() {
        let rank = index + 1
        let university = MockDataService.shared.mockUniversities.first { $0.id == match.program.universityId }
        
        majorsList += "\(rank). \(match.program.name) - \(university?.shortName ?? "")\n\(match.score)% dopasowania"
        
        if index < 2 { // Add spacing between items except for the last one
            majorsList += "\n\n"
        }
    }
    
    if majorsList.isEmpty {
        majorsList = "Analizuję najlepsze opcje dopasowane do Twoich preferencji i wyników..."
    } else {
        majorsList = "Oto kierunki, które najlepiej pasują do Twojego profilu:\n\n" + majorsList
    }
    
    return majorsList
}

private func generateWhyRecommended(for program: StudyProgram, answers: [String: Any], score: Int) -> String {
    let university = MockDataService.shared.mockUniversities.first { $0.id == program.universityId }
    
    // Create detailed explanations based on actual mock program fields
    switch program.field {
    case "Informatyka":
        return "Twoje mocne podstawy matematyczne są fundamentem programowania. Sektor IT oferuje najwyższe zarobki na polskim rynku - od 8 do 30 tys. zł miesięcznie."
    case "Data Science":
        return "Analiza danych to przyszłość biznesu. Twoje umiejętności matematyczne pozwolą odkrywać wartościowe wglądy z big data."
    case "Robotyka":
        return "Robotyka łączy programowanie z inżynieria mechaniczną. Będziesz tworzyć przyszłość automatyzacji i sztucznej inteligencji."
    case "Medycyna":
        return "Twoja fascynacja naukami przyrodniczymi to idealny fundament dla medycyny. Każdego dnia możesz ratować życie pacjentów."
    case "Stomatologia":
        return "Połączenie precyzji chirurgicznej z kontaktem z pacjentami. Stomatolodzy mają jedne z najwyższych zarobków w medycynie."
    case "Weterynaria":
        return "Jeśli kochasz zwierzęta i nauki przyrodnicze, weterynaria łączy obie pasje w jednej pięknej profesji."
    case "Fizjoterapia":
        return "Pomagasz ludziom odzyskać sprawność i życie bez bólu. Fizjoterapia to rosnaca branża z dużym zapotrzebowaniem."
    case "Prawo":
        return "Twoje umiejętności analityczne są kluczowe w interpretacji prawa. Prawnicy w top kancelariach zarabiają od 15 do 50 tys. zł."
    case "Ekonomia":
        return "Ekonomia to język biznesu. Otwiera drzwi do banków, konsultingu i start-upów z świetną perspektywą zarobkową."
    case "Stosunki międzynarodowe":
        return "W globalnym świecie eksperci od stosunków międzynarodowych są nieocenieni w dyplomacji i korporacjach."
    case "Inżynieria":
        return "Inżynierowie projektują przyszłość. Twoje pasje matematyczno-fizyczne znajdą praktyczne zastosowanie."
    case "Inżynieria środowiska":
        return "Walczysz ze zmianami klimatu projektując zrównoważone rozwiązania. Planeta potrzebuje takich inżynierów jak Ty."
    case "Energetyka":
        return "Odnawialne źródła energii to przyszłość. Będziesz budować świat niezależny od paliw kopalnych."
    case "Lotnictwo":
        return "Jeśli marzyłeś o lataniu, lotnictwo łączy pasję z wysoką technologią i świetną perspektywą kariery."
    case "Psychologia":
        return "Pomagasz ludziom w trudnych momentach i obserwujesz ich pozytywną transformację. Psychologia to klucz do zrozumienia człowieka."
    case "Praca socjalna":
        return "Jeśli chcesz pomagać najbardziej potrzebującym, praca socjalna daje możliwość realnej zmiany życia ludzi."
    case "Architektura":
        return "Projektowanie przestrzeni to sztuka użytkowa. Każdy Twój projekt będzie służyć ludziom przez dziesiątki lat."
    case "Architektura wnętrz":
        return "Tworzyjesz przestrzenie, w których ludzie czują się dobrze. Połączenie estetyki z funkcjonalnością."
    case "Wzornictwo":
        return "Design to język przyszłości. Od aplikacji po produkty - wzornictwo kształtuje nasze codzienne doświadczenia."
    case "Dziennikarstwo":
        return "Jako dziennikarz kształtujesz opinię publiczną i demaskujesz nadużycia. To czwarta władza w demokratycznym świecie."
    case "Biotechnologia":
        return "Twoja fascynacja życiem na poziomie molekularnym to klucz do przyszłości medycyny i rolnictwa personalnego."
    case "Sztuka":
        return "Sztuka to najczystsza forma ekspresji. Możesz dzielić się swoją wizją świata i wpływać na kulturę."
    case "Muzyka":
        return "Muzyka to uniwersalny język emocji. Możesz poruszać serca ludu i tworzyć dzieła na wieki."
    case "Sport":
        return "Sport to inwestycja w zdrowie na całe życie. Możesz inspirować innych do aktywnego trybu życia."
    case "Gastronomia":
        return "Gastronomia to sztuka smaków. Tworzysz culinary experiences, które pozostają w pamięci na zawsze."
    default:
        return generateDetailedExplanation(for: program, university: university, answers: answers)
    }
}

private func generateDetailedExplanation(for program: StudyProgram, university: University?, answers: [String: Any]) -> String {
    var reasons: [String] = []
    
    // University prestige
    if let priorities = answers["priorities"] as? Set<String> {
        if priorities.contains("Prestiż uczelni") && ["UW", "UJ", "PW", "AGH"].contains(program.universityId) {
            reasons.append("Prestiżowa uczelnia o uznanej pozycji w rankingach")
        }
    }
    
    // Location benefits
    if let location = answers["location"] as? String {
        if location.contains("dużym mieście") && ["Warszawa", "Kraków", "Wrocław", "Gdańsk"].contains(university?.city ?? "") {
            reasons.append("Studiowanie w dynamicznej metropolii z bogatymi możliwościami praktyk")
        }
    }
    
    // Default field-specific insight
    reasons.append("Kierunek o dobrych perspektywach zawodowych idealnie dopasowany do Twojego profilu")
    
    return reasons.joined(separator: ". ") + "."
}


// Pinterest Grid with dynamic sorting
struct PinterestGrid: View {
    let insightCards: [GridInsightCard]
    let programCards: [ProgramGridCard]
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left column
            VStack(spacing: 12) {
                ForEach(getLeftColumnItems(), id: \.id) { item in
                    item.view
                }
            }
            
            // Right column
            VStack(spacing: 12) {
                ForEach(getRightColumnItems(), id: \.id) { item in
                    item.view
                }
            }
        }
    }
    
    private func getLeftColumnItems() -> [PinterestItem] {
        let allItems = createAllItems()
        return distributeItems(allItems).left
    }
    
    private func getRightColumnItems() -> [PinterestItem] {
        let allItems = createAllItems()
        return distributeItems(allItems).right
    }
    
    private func createAllItems() -> [PinterestItem] {
        var items: [PinterestItem] = []
        
        // Add insight cards
        for (index, card) in insightCards.enumerated() {
            items.append(PinterestItem(
                id: "insight-\(index)",
                view: AnyView(card),
                priority: 0, // Insights have highest priority
                estimatedHeight: estimateHeight(for: card.description)
            ))
        }
        
        // Add program cards with priority based on rank
        for (index, card) in programCards.enumerated() {
            items.append(PinterestItem(
                id: "program-\(index)",
                view: AnyView(card),
                priority: 1, // All programs after insights
                estimatedHeight: 280 // Programs have consistent height due to images
            ))
        }
        
        return items.sorted { $0.priority < $1.priority }
    }
    
    private func distributeItems(_ items: [PinterestItem]) -> (left: [PinterestItem], right: [PinterestItem]) {
        var leftItems: [PinterestItem] = []
        var rightItems: [PinterestItem] = []
        var leftHeight: CGFloat = 0
        var rightHeight: CGFloat = 0
        
        // Separate insights and programs
        let insights = items.filter { $0.priority == 0 }
        let programs = items.filter { $0.priority == 1 }
        
        // Distribute insights using height balancing
        for item in insights {
            if leftHeight <= rightHeight {
                leftItems.append(item)
                leftHeight += item.estimatedHeight + 12
            } else {
                rightItems.append(item)
                rightHeight += item.estimatedHeight + 12
            }
        }
        
        // Distribute programs in strict rank order to maintain ranking
        // Always place #1 first, then alternate columns
        for (index, item) in programs.enumerated() {
            let rank = index + 1
            
            if rank == 1 {
                // Always put #1 in left column first
                leftItems.append(item)
            } else {
                // For remaining programs, balance by checking current column heights
                if leftItems.filter({ $0.priority == 1 }).count <= rightItems.filter({ $0.priority == 1 }).count {
                    leftItems.append(item)
                } else {
                    rightItems.append(item)
                }
            }
        }
        
        return (left: leftItems, right: rightItems)
    }
    
    private func estimateHeight(for text: String) -> CGFloat {
        // Rough estimation: 16pt per line + padding
        let lines = max(3, min(8, text.count / 60)) // Estimate lines based on character count
        return CGFloat(56 + (lines * 16) + 32) // Header + content + padding
    }
}

struct PinterestItem {
    let id: String
    let view: AnyView
    let priority: Int // 0 = highest priority, 2 = lowest
    let estimatedHeight: CGFloat
}

// Compact program card for Pinterest grid
struct ProgramGridCard: View {
    let program: StudyProgram
    let university: University
    let score: Int
    let rank: Int
    let reasons: [String]
    let whyRecommended: String
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(spacing: 0) {
                // Colored header with program name and score
                HStack {
                    Text(program.name)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(score)%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(scoreColor)
                
                // Program info with AI explanation
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text(university.shortName ?? university.displayName)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .font(.caption2)
                            .foregroundColor(.secondary.opacity(0.6))
                        
                        Text(university.city)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .lineLimit(1)
                    
                    // AI-generated explanation
                    Text(whyRecommended)
                        .font(.caption2)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
                .background(Color.white)
            }
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
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
    
    private var scoreColor: Color {
        if score >= 90 { return .green }
        else if score >= 80 { return .orange }
        else { return .purple }
    }
}

// AI Message panel
struct AIMessagePanel: View {
    let message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(.purple)
                
                Text("Personalizowana analiza AI")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.purple)
            }
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.05), Color.blue.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.2), lineWidth: 1)
        )
    }
}

// Grid card for two-column layout with notification badge
struct GridInsightCardWithBadge: View {
    let title: String
    let description: String
    let color: Color
    let badgeNumber: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Colored header with title and badge
            ZStack {
                // Header background
                color
                    .frame(height: 48)
                
                HStack {
                    // Title
                    Text(title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Notification badge
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                        
                        Text("\(badgeNumber)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(color)
                    }
                }
                .padding(.horizontal, 12)
            }
            
            // White content area
            Text(description)
                .font(.caption)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(12)
                .background(Color.white)
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

// Grid card for two-column layout
struct GridInsightCard: View {
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 0) {
            // Colored header with title (single line)
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(color)
            
            // White content area
            Text(description)
                .font(.caption)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(12)
                .background(Color.white)
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
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