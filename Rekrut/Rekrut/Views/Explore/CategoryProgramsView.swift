//
//  CategoryProgramsView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct CategoryProgramsView: View {
    let categoryName: String
    let categoryIcon: String
    let categoryColor: Color
    
    @State private var programs: [StudyProgram] = []
    @State private var isLoading = true
    @State private var selectedSubcategory: String? = nil
    @State private var allPrograms: [StudyProgram] = []
    
    // Comprehensive mapping of categories to fields
    private var categoryFields: [String] {
        switch categoryName {
        case "Informatyka i IT":
            return ["Informatyka", "Cyberbezpieczeństwo", "Data Science", "Sztuczna inteligencja", "Informatyka stosowana"]
        case "Medycyna i Zdrowie":
            return ["Medycyna", "Farmacja", "Fizjoterapia", "Pielęgniarstwo", "Stomatologia", "Ratownictwo medyczne", "Zdrowie publiczne"]
        case "Biznes i Ekonomia":
            return ["Ekonomia", "Zarządzanie", "Finanse", "Marketing", "Logistyka", "E-business", "Międzynarodowe stosunki gospodarcze"]
        case "Prawo i Administracja":
            return ["Prawo", "Administracja", "Administracja publiczna", "Bezpieczeństwo wewnętrzne", "Kryminologia", "Stosunki międzynarodowe"]
        case "Inżynieria i Technika":
            return ["Inżynieria", "Automatyka", "Robotyka", "Mechanika", "Elektronika", "Budownictwo", "Architektura", "Lotnictwo", "Inżynieria środowiska", "Energetyka"]
        case "Humanistyka i Języki":
            return ["Filologia", "Historia", "Filozofia", "Kulturoznawstwo", "Lingwistyka", "Przekład", "Dziennikarstwo", "Komunikacja społeczna"]
        case "Sztuka i Design":
            return ["Sztuka", "Grafika", "Design", "Wzornictwo", "Architektura wnętrz", "Fotografia", "Film", "Muzyka", "Teatr", "Konserwacja dzieł sztuki", "Animacja"]
        case "Sport i Turystyka":
            return ["Wychowanie fizyczne", "Sport", "Turystyka", "Rekreacja", "Dietetyka sportowa", "Fizjoterapia sportowa", "Zarządzanie sportem"]
        case "Nauki społeczne":
            return ["Psychologia", "Socjologia", "Pedagogika", "Praca socjalna", "Politologia", "Nauki o rodzinie", "Resocjalizacja", "Teologia", "Stosunki międzynarodowe"]
        case "Rolnictwo i Środowisko":
            return ["Rolnictwo", "Leśnictwo", "Ochrona środowiska", "Biologia", "Biotechnologia", "Weterynaria", "Ogrodnictwo", "Zootechnika", "Gastronomia"]
        default:
            return []
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Category header
                HStack(spacing: 12) {
                    Image(systemName: categoryIcon)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(categoryColor)
                        .cornerRadius(15)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(categoryName)
                            .font(.title2)
                            .bold()
                        
                        Text("\(programs.count) kierunków")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                } else {
                    // Popular subcategories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            // All button
                            Button(action: {
                                selectedSubcategory = nil
                            }) {
                                SubcategoryChip(
                                    title: "Wszystkie",
                                    color: categoryColor,
                                    count: allPrograms.count,
                                    isSelected: selectedSubcategory == nil
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            ForEach(getPopularSubcategories(), id: \.self) { subcategory in
                                Button(action: {
                                    selectedSubcategory = subcategory
                                }) {
                                    SubcategoryChip(
                                        title: subcategory,
                                        color: categoryColor,
                                        count: allPrograms.filter { $0.field.contains(subcategory) }.count,
                                        isSelected: selectedSubcategory == subcategory
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Programs list
                    VStack(spacing: 12) {
                        ForEach(filteredPrograms) { program in
                            ProgramRowCardWithSheet(
                                program: program,
                                categoryColor: categoryColor,
                                university: MockDataService.shared.mockUniversities.first { $0.id == program.universityId } ?? MockDataService.shared.mockUniversities.first!
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadPrograms()
        }
    }
    
    private var filteredPrograms: [StudyProgram] {
        if let subcategory = selectedSubcategory {
            return programs.filter { $0.field.contains(subcategory) }
        } else {
            return programs
        }
    }
    
    private func loadPrograms() {
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // In real app, this would filter from database
            let allProgramsTemp = MockDataService.shared.mockPrograms + generateCategorySpecificPrograms()
            
            programs = allProgramsTemp.filter { program in
                categoryFields.contains { field in
                    program.field.lowercased().contains(field.lowercased()) ||
                    program.name.lowercased().contains(field.lowercased())
                }
            }.sorted { (p1, p2) in
                // Sort by threshold if available, otherwise put programs with thresholds first
                switch (p1.lastYearThreshold, p2.lastYearThreshold) {
                case (let t1?, let t2?):
                    return t1 > t2  // Both have thresholds, sort by value
                case (nil, _):
                    return false   // p1 has no threshold, put it after p2
                case (_, nil):
                    return true    // p2 has no threshold, put p1 first
                }
            }
            
            allPrograms = programs
            isLoading = false
        }
    }
    
    private func getPopularSubcategories() -> [String] {
        let subcategories = Set(allPrograms.map { $0.field })
        return Array(subcategories).sorted()
    }
    
    private func generateCategorySpecificPrograms() -> [StudyProgram] {
        // Generate additional programs based on category
        switch categoryName {
        case "Sport i Turystyka":
            return [
                StudyProgram(
                    id: "awf-sport",
                    universityId: "awf",
                    name: "Sport",
                    field: "Wychowanie fizyczne",
                    degree: .bachelor,
                    mode: .stationary,
                    duration: 6,
                    language: "Polski",
                    description: "Profesjonalne przygotowanie sportowe",
                    requirements: AdmissionRequirements(
                        description: "Rekrutacja na podstawie wyników matury z WF-u oraz testów sprawnościowych",
                        formula: FormulaFactory.createSimpleFormula(
                            universityId: "awf",
                            programId: "awf-sport-prof",
                            components: [
                                (subject: "WF", level: "P", weight: 0.5),
                                (subject: "BIO", level: "P", weight: 0.3),
                                (subject: "POL", level: "P", weight: 0.2)
                            ],
                            mandatorySubjects: [],
                            lastYearThreshold: nil
                        ),
                        formulaId: "awf-sport-prof-formula",
                        minimumPoints: 70,
                        additionalExams: ["Test sprawności fizycznej"],
                        documents: ["Świadectwo maturalne", "Zaświadczenie lekarskie"],
                        deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                        admissionType: .mixed,
                        entranceExamDetails: nil
                    ),
                    tuitionFee: 0,
                    availableSlots: 100,
                    lastYearThreshold: 75.5,
                    tags: ["Trenerstwo", "Fitness", "Sport wyczynowy"]
                ),
                StudyProgram(
                    id: "uw-turystyka",
                    universityId: "uw",
                    name: "Turystyka i rekreacja",
                    field: "Turystyka",
                    degree: .bachelor,
                    mode: .stationary,
                    duration: 6,
                    language: "Polski",
                    description: "Zarządzanie w branży turystycznej",
                    requirements: AdmissionRequirements(
                        description: "Rekrutacja na podstawie wyników matury z WF-u oraz testów sprawnościowych",
                        formula: FormulaFactory.createSimpleFormula(
                            universityId: "awf",
                            programId: "awf-sport-prof",
                            components: [
                                (subject: "WF", level: "P", weight: 0.5),
                                (subject: "BIO", level: "P", weight: 0.3),
                                (subject: "POL", level: "P", weight: 0.2)
                            ],
                            mandatorySubjects: [],
                            lastYearThreshold: nil
                        ),
                        formulaId: "awf-sport-prof-formula",
                        minimumPoints: 70,
                        additionalExams: ["Test sprawności fizycznej"],
                        documents: ["Świadectwo maturalne", "Zaświadczenie lekarskie"],
                        deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                        admissionType: .mixed,
                        entranceExamDetails: nil
                    ),
                    tuitionFee: 0,
                    availableSlots: 80,
                    lastYearThreshold: 72.3,
                    tags: ["Hotelarstwo", "Pilotaż", "Event management"]
                )
            ]
        case "Sztuka i Design":
            return [
                StudyProgram(
                    id: "asp-grafika",
                    universityId: "asp",
                    name: "Grafika",
                    field: "Sztuka",
                    degree: .bachelor,
                    mode: .stationary,
                    duration: 6,
                    language: "Polski",
                    description: "Projektowanie graficzne i ilustracja",
                    requirements: AdmissionRequirements(
                        description: "Rekrutacja na podstawie portfolio oraz egzaminu wstępnego z rysunku i kompozycji",
                        formula: FormulaFactory.createSimpleFormula(
                            universityId: "asp",
                            programId: "asp-art",
                            components: [],
                            mandatorySubjects: [],
                            lastYearThreshold: nil
                        ),
                        formulaId: "asp-art-formula",
                        minimumPoints: nil,
                        additionalExams: ["Egzamin z rysunku", "Egzamin z kompozycji", "Przegląd portfolio"],
                        documents: ["Świadectwo maturalne", "Portfolio prac", "List motywacyjny"],
                        deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                        admissionType: .portfolio,
                        entranceExamDetails: EntranceExamDetails(
                            examType: "Egzamin praktyczny z portfolio",
                            stages: [
                                "Etap 1: Przegląd portfolio (15-20 prac)",
                                "Etap 2: Egzamin praktyczny z rysunku",
                                "Etap 3: Egzamin z kompozycji i koloru"
                            ],
                            description: "Trzydniowy egzamin praktyczny sprawdzający umiejętności artystyczne",
                            sampleTasksURL: nil,
                            preparationTips: "Przygotuj różnorodne portfolio pokazujące zakres umiejętności"
                        )
                    ),
                    tuitionFee: 0,
                    availableSlots: 40,
                    lastYearThreshold: nil,
                    tags: ["Ilustracja", "Typografia", "Branding"]
                )
            ]
        default:
            return []
        }
    }
}

struct SubcategoryChip: View {
    let title: String
    let color: Color
    let count: Int
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .medium)
            Text("(\(count))")
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(isSelected ? .white : color)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(isSelected ? color : color.opacity(0.1))
        .cornerRadius(20)
    }
}

struct ProgramRowCardWithSheet: View {
    let program: StudyProgram
    let categoryColor: Color
    let university: University
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            ProgramRowCard(
                program: program,
                categoryColor: categoryColor
            )
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
}

struct ProgramRowCard: View {
    let program: StudyProgram
    let categoryColor: Color
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
        HStack(spacing: 16) {
            // University logo placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(categoryColor.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(MockDataService.shared.mockUniversities.first { $0.id == program.universityId }?.shortName ?? "?")
                        .font(.caption)
                        .bold()
                        .foregroundColor(categoryColor)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(program.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(MockDataService.shared.mockUniversities.first { $0.id == program.universityId }?.name ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
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
                        Label("Brak danych", systemImage: "questionmark.circle")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let slots = program.availableSlots {
                        Label("\(slots) miejsc", systemImage: "person.3")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    
                    Label(program.degree.rawValue, systemImage: "graduationcap")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            if isSaved {
                Image(systemName: "bookmark.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
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
}

#Preview {
    NavigationView {
        CategoryProgramsView(
            categoryName: "Informatyka i IT",
            categoryIcon: "laptopcomputer",
            categoryColor: .blue
        )
    }
}