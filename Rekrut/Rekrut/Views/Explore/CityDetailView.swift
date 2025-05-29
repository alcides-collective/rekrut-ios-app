//
//  CityDetailView.swift
//  Rekrut
//
//  Created by Assistant on 29/05/2025.
//

import SwiftUI
import MapKit

struct CityDetailView: View {
    let city: CityInfo
    @State private var universities: [University] = []
    @State private var programs: [StudyProgram] = []
    @State private var selectedCategory = 0
    @State private var mapRegion = MKCoordinateRegion()
    @Environment(\.presentationMode) var presentationMode
    
    private let categories = ["Przegląd", "Uczelnie", "Życie studenckie", "Koszty", "Transport"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Section with Image
                ZStack(alignment: .bottomLeading) {
                    // City Image
                    AsyncImage(url: URL(string: city.imageURL ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipped()
                        case .failure(_), .empty:
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [city.color.opacity(0.8), city.color]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 300)
                        @unknown default:
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [city.color.opacity(0.8), city.color]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 300)
                        }
                    }
                    
                    // Gradient Overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0.2),
                            Color.black.opacity(0.6)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)
                    
                    // City Name Overlay
                    VStack(alignment: .leading, spacing: 8) {
                        Text(city.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            Label("\(city.universityCount) uczelni", systemImage: "building.2")
                            Label("\(getStudentCount()) tys. studentów", systemImage: "person.3")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(24)
                }
                
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    selectedCategory = index
                                }
                            }) {
                                Text(categories[index])
                                    .font(.subheadline)
                                    .fontWeight(selectedCategory == index ? .semibold : .regular)
                                    .foregroundColor(selectedCategory == index ? .blue : .secondary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(
                                        selectedCategory == index ?
                                        Color.blue.opacity(0.1) : Color.clear
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                }
                
                // Content based on selected category
                switch selectedCategory {
                case 0:
                    overviewSection
                case 1:
                    universitiesSection
                case 2:
                    studentLifeSection
                case 3:
                    costsSection
                case 4:
                    transportSection
                default:
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Zamknij") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            loadData()
            setupMapRegion()
        }
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(spacing: 24) {
            // Quick Stats
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    StatCard(
                        icon: "graduationcap.fill",
                        title: "Kierunków",
                        value: "\(programs.count)",
                        color: .blue
                    )
                    
                    StatCard(
                        icon: "building.2.fill",
                        title: "Uczelni",
                        value: "\(city.universityCount)",
                        color: .green
                    )
                }
                
                HStack(spacing: 16) {
                    StatCard(
                        icon: "person.3.fill",
                        title: "Studentów",
                        value: "\(getStudentCount())k",
                        color: .orange
                    )
                    
                    StatCard(
                        icon: "star.fill",
                        title: "Ranking",
                        value: getCityRanking(),
                        color: .purple
                    )
                }
            }
            .padding(.horizontal)
            
            // Map
            VStack(alignment: .leading, spacing: 12) {
                Text("Lokalizacja")
                    .font(.headline)
                    .padding(.horizontal)
                
                Map(coordinateRegion: $mapRegion, annotationItems: universities) { university in
                    MapPin(coordinate: getCityCoordinate(), tint: city.color)
                }
                .frame(height: 200)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            // Description
            VStack(alignment: .leading, spacing: 12) {
                Text("O mieście")
                    .font(.headline)
                
                Text(getCityDescription())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .padding(.horizontal)
            
            // Key Features
            VStack(alignment: .leading, spacing: 12) {
                Text("Dlaczego warto studiować w \(city.name)?")
                    .font(.headline)
                
                ForEach(getCityFeatures(), id: \.self) { feature in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.subheadline)
                        
                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            // Popular Programs
            VStack(alignment: .leading, spacing: 12) {
                Text("Popularne kierunki")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(programs.prefix(5)) { program in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(program.name)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                
                                Text(universities.first { $0.id == program.universityId }?.shortName ?? "")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer(minLength: 40)
        }
        .padding(.top, 16)
    }
    
    // MARK: - Universities Section
    private var universitiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(universities.count) uczelni w \(city.name)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            ForEach(universities) { university in
                UniversityRowCard(university: university, programCount: programs.filter { $0.universityId == university.id }.count)
                    .padding(.horizontal)
            }
            
            Spacer(minLength: 40)
        }
        .padding(.top, 16)
    }
    
    // MARK: - Student Life Section
    private var studentLifeSection: some View {
        VStack(spacing: 24) {
            // Entertainment
            SectionCard(
                icon: "sparkles",
                title: "Rozrywka i kultura",
                items: getEntertainmentOptions()
            )
            
            // Food Scene
            SectionCard(
                icon: "fork.knife",
                title: "Gastronomia",
                items: getFoodOptions()
            )
            
            // Sports & Recreation
            SectionCard(
                icon: "figure.run",
                title: "Sport i rekreacja",
                items: getSportsOptions()
            )
            
            // Student Organizations
            SectionCard(
                icon: "person.3.fill",
                title: "Organizacje studenckie",
                items: getStudentOrganizations()
            )
            
            Spacer(minLength: 40)
        }
        .padding(.top, 16)
        .padding(.horizontal)
    }
    
    // MARK: - Costs Section
    private var costsSection: some View {
        VStack(spacing: 24) {
            // Average Costs
            VStack(alignment: .leading, spacing: 16) {
                Text("Średnie miesięczne koszty")
                    .font(.headline)
                
                CostRow(category: "Mieszkanie (pokój)", range: getAccommodationCost())
                CostRow(category: "Wyżywienie", range: "600-1000 zł")
                CostRow(category: "Transport", range: getTransportCost())
                CostRow(category: "Rozrywka", range: "200-500 zł")
                CostRow(category: "Inne wydatki", range: "200-400 zł")
                
                Divider()
                
                HStack {
                    Text("Suma")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(getTotalCost())
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                Text("* Koszty mogą się różnić w zależności od stylu życia")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            
            // Accommodation Options
            VStack(alignment: .leading, spacing: 12) {
                Text("Opcje zakwaterowania")
                    .font(.headline)
                
                AccommodationOption(
                    type: "Akademik",
                    price: getStudentDormCost(),
                    description: "Najtańsza opcja, życie studenckie"
                )
                
                AccommodationOption(
                    type: "Pokój w mieszkaniu",
                    price: getRoomCost(),
                    description: "Dobry stosunek jakości do ceny"
                )
                
                AccommodationOption(
                    type: "Kawalerka",
                    price: getStudioCost(),
                    description: "Prywatność i niezależność"
                )
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    // MARK: - Transport Section
    private var transportSection: some View {
        VStack(spacing: 24) {
            // Public Transport
            VStack(alignment: .leading, spacing: 16) {
                Label("Komunikacja miejska", systemImage: "tram.fill")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 12) {
                    TransportInfo(
                        type: "Bilet studencki miesięczny",
                        price: getStudentTicketPrice(),
                        description: "51% zniżki dla studentów"
                    )
                    
                    TransportInfo(
                        type: "Dostępne środki transportu",
                        price: "",
                        description: getAvailableTransport()
                    )
                    
                    TransportInfo(
                        type: "Aplikacja mobilna",
                        price: "",
                        description: getTransportApp()
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            // Bike Infrastructure
            if hasBikeInfrastructure() {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Infrastruktura rowerowa", systemImage: "bicycle")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("System roweru miejskiego")
                        }
                        .font(.subheadline)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("\(getBikePathsLength()) km ścieżek rowerowych")
                        }
                        .font(.subheadline)
                        
                        Text("Koszt: \(getBikeRentalCost())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            
            // Connections
            VStack(alignment: .leading, spacing: 16) {
                Label("Połączenia", systemImage: "arrow.triangle.branch")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 12) {
                    ConnectionInfo(icon: "airplane", title: "Lotnisko", description: getAirportInfo())
                    ConnectionInfo(icon: "tram", title: "Dworzec główny", description: "Połączenia krajowe i międzynarodowe")
                    ConnectionInfo(icon: "car", title: "Autostrady", description: getHighwayAccess())
                }
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    // MARK: - Helper Functions
    private func loadData() {
        universities = MockDataService.shared.mockUniversities.filter { $0.city == city.name }
        programs = MockDataService.shared.mockPrograms.filter { program in
            universities.contains { $0.id == program.universityId }
        }
    }
    
    private func setupMapRegion() {
        let coordinate = getCityCoordinate()
        mapRegion = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
    
    private func getCityCoordinate() -> CLLocationCoordinate2D {
        switch city.name {
        case "Warszawa": return CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122)
        case "Kraków": return CLLocationCoordinate2D(latitude: 50.0647, longitude: 19.9450)
        case "Wrocław": return CLLocationCoordinate2D(latitude: 51.1079, longitude: 17.0385)
        case "Poznań": return CLLocationCoordinate2D(latitude: 52.4064, longitude: 16.9252)
        case "Gdańsk": return CLLocationCoordinate2D(latitude: 54.3520, longitude: 18.6466)
        case "Łódź": return CLLocationCoordinate2D(latitude: 51.7592, longitude: 19.4560)
        case "Katowice": return CLLocationCoordinate2D(latitude: 50.2649, longitude: 19.0238)
        case "Lublin": return CLLocationCoordinate2D(latitude: 51.2465, longitude: 22.5684)
        case "Szczecin": return CLLocationCoordinate2D(latitude: 53.4285, longitude: 14.5528)
        default: return CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122)
        }
    }
    
    private func getStudentCount() -> Int {
        switch city.name {
        case "Warszawa": return 250
        case "Kraków": return 170
        case "Wrocław": return 140
        case "Poznań": return 120
        case "Gdańsk": return 75
        case "Łódź": return 85
        case "Katowice": return 80
        case "Lublin": return 65
        case "Szczecin": return 45
        default: return 50
        }
    }
    
    private func getCityRanking() -> String {
        switch city.name {
        case "Warszawa": return "#1"
        case "Kraków": return "#2"
        case "Wrocław": return "#3"
        case "Poznań": return "#4"
        case "Gdańsk": return "#5"
        default: return "Top 10"
        }
    }
    
    private func getCityDescription() -> String {
        switch city.name {
        case "Warszawa":
            return "Stolica Polski i największy ośrodek akademicki w kraju. Warszawa oferuje najszerszy wybór uczelni i kierunków studiów, dynamiczny rynek pracy oraz bogate życie kulturalne. To idealne miejsce dla ambitnych studentów szukających międzynarodowych możliwości."
        case "Kraków":
            return "Historyczna stolica Polski z najstarszym uniwersytetem w kraju. Kraków łączy bogatą tradycję akademicką z nowoczesnym podejściem do edukacji. Miasto słynie z niepowtarzalnej atmosfery studenckiej i tętniącego życiem Starego Miasta."
        case "Wrocław":
            return "Miasto stu mostów i dynamicznie rozwijający się ośrodek akademicki. Wrocław przyciąga studentów połączeniem nowoczesnej infrastruktury, bogatej oferty kulturalnej i stosunkowo niskich kosztów życia."
        case "Poznań":
            return "Miasto targów i biznesu z silnymi tradycjami akademickimi. Poznań oferuje doskonałe warunki do studiowania kierunków związanych z ekonomią i biznesem, a także rozwiniętą bazę praktyk i staży."
        case "Gdańsk":
            return "Nadmorska metropolia z unikalnymi kierunkami morskimi i technicznymi. Trójmiasto oferuje wysoką jakość życia, dostęp do plaży i dynamicznie rozwijający się sektor IT i logistyki."
        default:
            return "Dynamiczne miasto akademickie oferujące wysoką jakość kształcenia i bogate życie studenckie. Idealne miejsce do rozwoju osobistego i zawodowego."
        }
    }
    
    private func getCityFeatures() -> [String] {
        switch city.name {
        case "Warszawa":
            return [
                "Najlepsze perspektywy zawodowe w Polsce",
                "Międzynarodowe środowisko akademickie",
                "Dostęp do praktyk w największych firmach",
                "Bogate życie kulturalne i rozrywkowe",
                "Doskonała komunikacja miejska"
            ]
        case "Kraków":
            return [
                "Najstarsza tradycja akademicka w Polsce",
                "Niepowtarzalna atmosfera studenckiego miasta",
                "Tanie akademiki w centrum miasta",
                "Rozwinięta scena kulturalna i artystyczna",
                "Bliskość gór i atrakcji turystycznych"
            ]
        case "Wrocław":
            return [
                "Jedno z najbardziej studenckich miast w Polsce",
                "Rozbudowana sieć tramwajowa",
                "Liczne festiwale i wydarzenia kulturalne",
                "Prężnie rozwijający się rynek IT",
                "Przystępne ceny wynajmu mieszkań"
            ]
        default:
            return [
                "Przyjazne środowisko akademickie",
                "Dobre połączenia komunikacyjne",
                "Rozwinięta infrastruktura studencka",
                "Możliwości rozwoju zawodowego",
                "Ciekawe życie kulturalne"
            ]
        }
    }
    
    // Cost Helper Functions
    private func getAccommodationCost() -> String {
        switch city.name {
        case "Warszawa": return "800-2000 zł"
        case "Kraków": return "700-1800 zł"
        case "Wrocław": return "600-1600 zł"
        case "Poznań": return "600-1500 zł"
        case "Gdańsk": return "700-1700 zł"
        default: return "500-1400 zł"
        }
    }
    
    private func getTransportCost() -> String {
        switch city.name {
        case "Warszawa": return "55 zł"
        case "Kraków": return "57 zł"
        case "Wrocław": return "52 zł"
        default: return "50 zł"
        }
    }
    
    private func getTotalCost() -> String {
        switch city.name {
        case "Warszawa": return "2200-4200 zł"
        case "Kraków": return "1900-3800 zł"
        case "Wrocław": return "1700-3400 zł"
        default: return "1500-3000 zł"
        }
    }
    
    private func getStudentDormCost() -> String {
        switch city.name {
        case "Warszawa": return "400-600 zł"
        case "Kraków": return "350-550 zł"
        default: return "300-500 zł"
        }
    }
    
    private func getRoomCost() -> String {
        switch city.name {
        case "Warszawa": return "800-1500 zł"
        case "Kraków": return "700-1300 zł"
        default: return "600-1200 zł"
        }
    }
    
    private func getStudioCost() -> String {
        switch city.name {
        case "Warszawa": return "2000-3500 zł"
        case "Kraków": return "1800-3000 zł"
        default: return "1500-2500 zł"
        }
    }
    
    // Transport Helper Functions
    private func getStudentTicketPrice() -> String {
        switch city.name {
        case "Warszawa": return "55 zł/miesiąc"
        case "Kraków": return "57 zł/miesiąc"
        case "Wrocław": return "52 zł/miesiąc"
        default: return "50 zł/miesiąc"
        }
    }
    
    private func getAvailableTransport() -> String {
        switch city.name {
        case "Warszawa": return "Metro, tramwaje, autobusy, SKM"
        case "Kraków": return "Tramwaje, autobusy"
        case "Wrocław": return "Tramwaje, autobusy"
        case "Gdańsk": return "Tramwaje, autobusy, SKM"
        default: return "Tramwaje, autobusy"
        }
    }
    
    private func getTransportApp() -> String {
        switch city.name {
        case "Warszawa": return "Jakdojade, Warsaw Public Transport"
        case "Kraków": return "Jakdojade, iMPK"
        case "Wrocław": return "Jakdojade, iMPK Wrocław"
        default: return "Jakdojade"
        }
    }
    
    private func hasBikeInfrastructure() -> Bool {
        return ["Warszawa", "Kraków", "Wrocław", "Poznań", "Gdańsk"].contains(city.name)
    }
    
    private func getBikePathsLength() -> Int {
        switch city.name {
        case "Warszawa": return 600
        case "Kraków": return 200
        case "Wrocław": return 250
        default: return 100
        }
    }
    
    private func getBikeRentalCost() -> String {
        return "20 zł/miesiąc (pierwsze 20 min bezpłatne)"
    }
    
    private func getAirportInfo() -> String {
        switch city.name {
        case "Warszawa": return "Lotnisko Chopina (15 min)"
        case "Kraków": return "Lotnisko Balice (30 min)"
        case "Wrocław": return "Port Lotniczy Wrocław (20 min)"
        case "Gdańsk": return "Lotnisko im. Lecha Wałęsy (25 min)"
        default: return "Lotnisko regionalne"
        }
    }
    
    private func getHighwayAccess() -> String {
        switch city.name {
        case "Warszawa": return "A2 (Berlin-Moskwa), A1, S7, S8"
        case "Kraków": return "A4 (Drezno-Kijów), S7"
        case "Wrocław": return "A4, A8, S8"
        default: return "Dobre połączenia drogowe"
        }
    }
    
    // Student Life Helper Functions
    private func getEntertainmentOptions() -> [String] {
        switch city.name {
        case "Warszawa":
            return ["Teatry i musicale na światowym poziomie", "Kluby studenckie: Hybrydy, Proxima", "Festiwale: Orange Warsaw, Wianki"]
        case "Kraków":
            return ["Kazimierz - dzielnica klubów i pubów", "Teatry studenckie i kabaret", "Festiwale: OFF Festival, Wianki"]
        default:
            return ["Kluby studenckie", "Kina i teatry", "Festiwale muzyczne"]
        }
    }
    
    private func getFoodOptions() -> [String] {
        switch city.name {
        case "Warszawa":
            return ["Food trucki i street food", "Restauracje z całego świata", "Studenckie bary mleczne"]
        case "Kraków":
            return ["Słynne obwarzanki", "Tanie jadłodajnie w centrum", "Knajpki na Kazimierzu"]
        default:
            return ["Bary studenckie", "Food courty", "Lokalna kuchnia"]
        }
    }
    
    private func getSportsOptions() -> [String] {
        return ["Siłownie uniwersyteckie", "Baseny studenckie", "Kluby sportowe AZS", "Ścieżki biegowe i rowerowe"]
    }
    
    private func getStudentOrganizations() -> [String] {
        return ["Samorząd studencki", "Koła naukowe", "Organizacje wolontariackie", "Kluby zainteresowań"]
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct UniversityRowCard: View {
    let university: University
    let programCount: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // University Logo Placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(university.shortName ?? String(university.name.prefix(2)))
                        .font(.headline)
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(university.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 12) {
                    Label("\(programCount) kierunków", systemImage: "book")
                    
                    if let ranking = university.ranking {
                        Label("#\(ranking) w Polsce", systemImage: "star")
                    }
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
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct SectionCard: View {
    let icon: String
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(item)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct CostRow: View {
    let category: String
    let range: String
    
    var body: some View {
        HStack {
            Text(category)
                .font(.subheadline)
            Spacer()
            Text(range)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct AccommodationOption: View {
    let type: String
    let price: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(type)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(price)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TransportInfo: View {
    let type: String
    let price: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(type)
                    .font(.subheadline)
                    .fontWeight(.medium)
                if !price.isEmpty {
                    Spacer()
                    Text(price)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ConnectionInfo: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - CityInfo Extension
// CityInfo is now defined in ExploreFeedComponents.swift

#Preview {
    NavigationView {
        CityDetailView(city: CityInfo(
            name: "Warszawa",
            universityCount: 76,
            imageURL: "https://images.pexels.com/photos/2613438/pexels-photo-2613438.jpeg",
            color: .red
        ))
    }
}