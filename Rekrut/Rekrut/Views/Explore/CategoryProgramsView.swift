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
            return ["Inżynieria", "Automatyka", "Robotyka", "Mechanika", "Elektronika", "Budownictwo", "Architektura", "Lotnictwo"]
        case "Humanistyka i Języki":
            return ["Filologia", "Historia", "Filozofia", "Kulturoznawstwo", "Lingwistyka", "Przekład", "Dziennikarstwo", "Komunikacja społeczna"]
        case "Sztuka i Design":
            return ["Sztuka", "Grafika", "Design", "Wzornictwo", "Architektura wnętrz", "Fotografia", "Film", "Muzyka", "Teatr", "Konserwacja dzieł sztuki"]
        case "Sport i Turystyka":
            return ["Wychowanie fizyczne", "Sport", "Turystyka", "Rekreacja", "Dietetyka sportowa", "Fizjoterapia sportowa", "Zarządzanie sportem"]
        case "Nauki społeczne":
            return ["Psychologia", "Socjologia", "Pedagogika", "Praca socjalna", "Politologia", "Nauki o rodzinie", "Resocjalizacja", "Teologia"]
        case "Rolnictwo i Środowisko":
            return ["Rolnictwo", "Leśnictwo", "Ochrona środowiska", "Biologia", "Biotechnologia", "Weterynaria", "Ogrodnictwo", "Zootechnika"]
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
                            .fontWeight(.bold)
                        
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
                        HStack(spacing: 12) {
                            ForEach(getPopularSubcategories(), id: \.self) { subcategory in
                                SubcategoryChip(
                                    title: subcategory,
                                    color: categoryColor,
                                    count: programs.filter { $0.field.contains(subcategory) }.count
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Programs list
                    VStack(spacing: 12) {
                        ForEach(programs) { program in
                            NavigationLink(destination: ProgramDetailView(
                                program: program,
                                university: MockDataService.shared.mockUniversities.first { $0.id == program.universityId }!
                            )) {
                                ProgramRowCard(program: program, categoryColor: categoryColor)
                            }
                            .buttonStyle(PlainButtonStyle())
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
    
    private func loadPrograms() {
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // In real app, this would filter from database
            let allPrograms = MockDataService.shared.mockPrograms + generateCategorySpecificPrograms()
            
            programs = allPrograms.filter { program in
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
            
            isLoading = false
        }
    }
    
    private func getPopularSubcategories() -> [String] {
        let subcategories = Set(programs.map { $0.field })
        return Array(subcategories.prefix(5)).sorted()
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
                    requirements: MockDataService.shared.mockPrograms[0].requirements,
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
                    requirements: MockDataService.shared.mockPrograms[0].requirements,
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
                    requirements: MockDataService.shared.mockPrograms[0].requirements,
                    tuitionFee: 0,
                    availableSlots: 40,
                    lastYearThreshold: 80.0,
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
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            Text("\(count)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(20)
    }
}

struct ProgramRowCard: View {
    let program: StudyProgram
    let categoryColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // University logo placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(categoryColor.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(MockDataService.shared.mockUniversities.first { $0.id == program.universityId }?.shortName ?? "")
                        .font(.caption)
                        .fontWeight(.bold)
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
                        Label("\(Int(threshold)) pkt", systemImage: "chart.line.uptrend.xyaxis")
                            .font(.caption)
                            .foregroundColor(.blue)
                    } else {
                        Label("Brak danych", systemImage: "questionmark.circle")
                            .font(.caption)
                            .foregroundColor(.gray)
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
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
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