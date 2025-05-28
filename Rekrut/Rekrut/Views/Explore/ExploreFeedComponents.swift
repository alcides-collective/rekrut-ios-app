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
                .foregroundColor(.gray)
            
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
                                Color.gray.opacity(0.1)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
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
                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    
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
                // Pills in top right
                HStack(spacing: 8) {
                    // Degree type pill
                    Text(program.degree == .engineer ? "inż." : program.degree == .bachelor ? "lic." : program.degree == .master ? "mgr" : "mgr")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.9))
                        .foregroundColor(.black.opacity(0.8))
                        .cornerRadius(12)
                    
                    // Score indicator
                    if let threshold = program.lastYearThreshold {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(getAdmissionChanceColor(threshold: threshold))
                                .frame(width: 8, height: 8)
                            Text("\(Int(threshold))")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                    } else {
                        // Fallback for missing threshold
                        Text("Brak danych")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.7))
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
                    .navigationBarItems(trailing: Button("Zamknij") {
                        showingDetail = false
                    })
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
}

struct RecommendedProgramCard: View {
    let program: StudyProgram
    let university: University?
    @State private var showingDetail = false
    
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
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(program.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(university?.displayName ?? "") • \(program.degree.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        if let slots = program.availableSlots {
                            Label("\(slots) miejsc", systemImage: "person.3.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
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
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 10)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                ProgramDetailView(program: program, university: university ?? MockDataService.shared.mockUniversities.first!)
                    .navigationBarItems(trailing: Button("Zamknij") {
                        showingDetail = false
                    })
            }
        }
    }
}

struct CategoryGridView: View {
    let categories = [
        ("Informatyka i IT", "laptopcomputer", Color.blue, 234),
        ("Medycyna i Zdrowie", "cross.case.fill", Color.red, 156),
        ("Biznes i Ekonomia", "chart.line.uptrend.xyaxis", Color.green, 189),
        ("Prawo i Administracja", "scale.3d", Color.orange, 98),
        ("Inżynieria i Technika", "gearshape.fill", Color.purple, 267),
        ("Humanistyka i Języki", "book.fill", Color.pink, 145),
        ("Sztuka i Design", "paintbrush.fill", Color.indigo, 87),
        ("Sport i Turystyka", "figure.run", Color.mint, 56),
        ("Nauki społeczne", "person.3.fill", Color.teal, 123),
        ("Rolnictwo i Środowisko", "leaf.fill", Color(red: 0.2, green: 0.6, blue: 0.2), 45)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(categories.enumerated()), id: \.element.0) { index, category in
                NavigationLink(destination: CategoryProgramsView(
                    categoryName: category.0,
                    categoryIcon: category.1,
                    categoryColor: category.2
                )) {
                    CategoryListRow(
                        title: category.0,
                        icon: category.1,
                        color: category.2,
                        programCount: category.3
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                if index < categories.count - 1 {
                    Divider()
                        .padding(.leading, 72)
                }
            }
        }
        .background(Color.white)
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
        .background(Color.white)
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
                .fill(Color.gray.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(university.shortName ?? String(university.name.prefix(2)))
                        .font(.headline)
                        .foregroundColor(.gray)
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
                    .navigationBarItems(trailing: Button("Zamknij") {
                        showingDetail = false
                    })
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
        ZStack(alignment: .bottom) {
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
            VStack(spacing: 4) {
                Text(university.shortName ?? university.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(university.city)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.bottom, 12)
        }
        .frame(width: 140, height: 140)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CityInfo {
    let name: String
    let universityCount: Int
    let imageURL: String
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
            if let url = URL(string: city.imageURL),
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