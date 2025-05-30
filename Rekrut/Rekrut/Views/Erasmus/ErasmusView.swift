//
//  ErasmusView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct ErasmusView: View {
    @State private var showingProfile = false
    @StateObject private var firebaseService = FirebaseService.shared
    @State private var showNavBar = false
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        // Custom inline header
                        HStack {
                            Text("Erasmus+")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {
                                showingProfile = true
                            }) {
                                Image(systemName: firebaseService.isAuthenticated ? "person.crop.circle.fill" : "person.crop.circle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onChange(of: geometry.frame(in: .global).minY) { value in
                                        withAnimation(.easeInOut(duration: 0.1)) {
                                            showNavBar = value < 50
                                        }
                                    }
                            }
                        )
                        
                        ErasmusContentView()
                    }
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .top) {
                // Navigation bar that appears on scroll
                if showNavBar {
                    VStack(spacing: 0) {
                        Color.clear
                            .frame(height: 50)
                        
                        HStack {
                            Text("Erasmus+")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 56)
                        .background(.regularMaterial)
                        .overlay(alignment: .bottom) {
                            Divider()
                        }
                    }
                    .ignoresSafeArea()
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

struct ErasmusContentView: View {
    @State private var popularUniversities: [ErasmusUniversity] = []
    @State private var popularCities: [CityInfo] = []
    @State private var countries: [String] = []
    @State private var selectedCountry: String?
    @State private var selectedCity: String?
    @State private var selectedField: String?
    
    let fields = ["Wszystkie dziedziny", "Informatyka", "Ekonomia", "Medycyna", "Prawo", "Inżynieria", "Psychologia"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Filters
            ErasmusFilterSection(
                selectedCountry: $selectedCountry,
                selectedCity: $selectedCity,
                selectedField: $selectedField,
                fields: fields
            )
                
                // Popular Universities Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(
                        title: "Popularne uczelnie",
                        icon: "building.columns",
                        actionText: "Zobacz wszystkie",
                        action: { }
                    )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(mockErasmusUniversities) { university in
                                UniversityCard(university: university)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5) // Add padding for shadows
                    }
                }
                
                // Popular Cities Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(
                        title: "Popularne miasta",
                        icon: "mappin.circle",
                        actionText: "Zobacz wszystkie",
                        action: { }
                    )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(mockErasmusCities) { city in
                                CityCard(city: city)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5) // Add padding for shadows
                    }
                }
                
                // Countries Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(
                        title: "Kraje programu Erasmus+",
                        icon: "globe.europe.africa",
                        actionText: nil,
                        action: { }
                    )
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(mockErasmusCountries, id: \.self) { country in
                            CountryCard(country: country)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 24)
            }
        .background(Color(.systemBackground))
    }
}

// MARK: - Filter Section
struct ErasmusFilterSection: View {
    @Binding var selectedCountry: String?
    @Binding var selectedCity: String?
    @Binding var selectedField: String?
    let fields: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Country Filter
                Menu {
                    Button(action: { selectedCountry = nil }) {
                        Label("Wszystkie kraje", systemImage: selectedCountry == nil ? "checkmark" : "")
                    }
                    Divider()
                    ForEach(mockErasmusCountries, id: \.self) { country in
                        Button(action: { selectedCountry = country }) {
                            Label(country, systemImage: selectedCountry == country ? "checkmark" : "")
                        }
                    }
                } label: {
                    ErasmusFilterChip(
                        title: selectedCountry ?? "Kraj",
                        isActive: selectedCountry != nil,
                        icon: "globe"
                    )
                }
                
                // City Filter
                Menu {
                    Button(action: { selectedCity = nil }) {
                        Label("Wszystkie miasta", systemImage: selectedCity == nil ? "checkmark" : "")
                    }
                    Divider()
                    ForEach(mockErasmusCities.map { $0.name }, id: \.self) { city in
                        Button(action: { selectedCity = city }) {
                            Label(city, systemImage: selectedCity == city ? "checkmark" : "")
                        }
                    }
                } label: {
                    ErasmusFilterChip(
                        title: selectedCity ?? "Miasto",
                        isActive: selectedCity != nil,
                        icon: "mappin"
                    )
                }
                
                // Field Filter
                Menu {
                    ForEach(fields, id: \.self) { field in
                        Button(action: { selectedField = field == "Wszystkie dziedziny" ? nil : field }) {
                            Label(field, systemImage: (selectedField == field || (selectedField == nil && field == "Wszystkie dziedziny")) ? "checkmark" : "")
                        }
                    }
                } label: {
                    ErasmusFilterChip(
                        title: selectedField ?? "Dziedzina",
                        isActive: selectedField != nil,
                        icon: "book"
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct ErasmusFilterChip: View {
    let title: String
    let isActive: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            Text(title)
                .font(.subheadline)
            Image(systemName: "chevron.down")
                .font(.caption2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isActive ? Color.blue.opacity(0.1) : Color(.systemGray6))
        .foregroundColor(isActive ? .blue : .primary)
        .cornerRadius(20)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
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

// MARK: - University Card
struct UniversityCard: View {
    let university: ErasmusUniversity
    @State private var imageLoadFailed = false
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background - either image or gradient
            if let imageURL = university.imageURL,
                   !imageLoadFailed,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 280, height: 160)
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
                                Color.secondary.opacity(0.1)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                            }
                        @unknown default:
                            backgroundGradient
                        }
                    }
                } else {
                    backgroundGradient
                }
                
                // Content overlay
                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    
                    HStack {
                        Text(university.country)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(12)
                        
                        Spacer()
                    }
                    
                    Text(university.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin")
                                .font(.caption)
                            Text(university.city)
                                .font(.caption)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.caption)
                            Text("\(university.availableSpots) miejsc")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.white.opacity(0.9))
                }
                .padding()
        }
        .frame(width: 280, height: 160)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - City Card
struct CityCard: View {
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
                   !imageLoadFailed,
                   let url = URL(string: imageURL) {
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
                                Color.secondary.opacity(0.1)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
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
                    
                    Text(getCityCountry(city.name))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                    
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
    
    private func getCityCountry(_ cityName: String) -> String {
        // Map Erasmus cities to their countries
        let cityCountryMap = [
            "Barcelona": "Hiszpania",
            "Amsterdam": "Holandia",
            "Praga": "Czechy",
            "Lizbona": "Portugalia",
            "Wiedeń": "Austria",
            "Berlin": "Niemcy",
            "Paryż": "Francja",
            "Rzym": "Włochy",
            "Madryt": "Hiszpania",
            "Monachium": "Niemcy"
        ]
        return cityCountryMap[cityName] ?? "Europa"
    }
}

// MARK: - Country Card
struct CountryCard: View {
    let country: String
    
    var body: some View {
        NavigationLink(destination: Text("Uczelnie w \(country)")) {
            HStack {
                Text(countryFlag(for: country))
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(country)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("\(Int.random(in: 10...50)) uczelni")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private func countryFlag(for country: String) -> String {
        let flags: [String: String] = [
            "Niemcy": "🇩🇪",
            "Francja": "🇫🇷",
            "Hiszpania": "🇪🇸",
            "Włochy": "🇮🇹",
            "Holandia": "🇳🇱",
            "Belgia": "🇧🇪",
            "Austria": "🇦🇹",
            "Czechy": "🇨🇿",
            "Portugalia": "🇵🇹",
            "Szwecja": "🇸🇪",
            "Norwegia": "🇳🇴",
            "Dania": "🇩🇰"
        ]
        return flags[country] ?? "🇪🇺"
    }
}

// MARK: - Models
struct ErasmusUniversity: Identifiable {
    let id = UUID()
    let name: String
    let city: String
    let country: String
    let availableSpots: Int
    let partnershipsCount: Int
    let imageURL: String?
}

// ErasmusCity is now deprecated - use CityInfo from ExploreFeedComponents instead

// MARK: - Mock Data
let mockErasmusUniversities = [
    ErasmusUniversity(name: "Technical University of Munich", city: "Monachium", country: "Niemcy", availableSpots: 25, partnershipsCount: 12, imageURL: "https://images.unsplash.com/photo-1599057234909-3e11ca6d5fd9?w=800"),
    ErasmusUniversity(name: "Sorbonne Université", city: "Paryż", country: "Francja", availableSpots: 20, partnershipsCount: 8, imageURL: "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800"),
    ErasmusUniversity(name: "Universidad Complutense", city: "Madryt", country: "Hiszpania", availableSpots: 30, partnershipsCount: 15, imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=800"),
    ErasmusUniversity(name: "Sapienza University", city: "Rzym", country: "Włochy", availableSpots: 18, partnershipsCount: 10, imageURL: "https://images.unsplash.com/photo-1515542622106-78bda8ba0e5b?w=800")
]

let mockErasmusCities: [CityInfo] = [
    CityInfo(name: "Barcelona", universityCount: 8, imageURL: "https://images.unsplash.com/photo-1583422409516-2895a77efded?w=800", color: .orange),
    CityInfo(name: "Amsterdam", universityCount: 5, imageURL: "https://images.unsplash.com/photo-1534351590666-13e3e96b5017?w=800", color: .blue),
    CityInfo(name: "Praga", universityCount: 6, imageURL: "https://images.unsplash.com/photo-1541849546-216549ae216d?w=800", color: .purple),
    CityInfo(name: "Lizbona", universityCount: 4, imageURL: "https://images.unsplash.com/photo-1585208798174-6cedd86e019a?w=800", color: .cyan),
    CityInfo(name: "Wiedeń", universityCount: 7, imageURL: "https://images.unsplash.com/photo-1516550893923-42d28e5677af?w=800", color: .red)
]

let mockErasmusCountries = [
    "Niemcy", "Francja", "Hiszpania", "Włochy",
    "Holandia", "Belgia", "Austria", "Czechy",
    "Portugalia", "Szwecja", "Norwegia", "Dania"
]

#Preview {
    NavigationView {
        ErasmusView()
    }
}