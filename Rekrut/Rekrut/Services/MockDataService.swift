//
//  MockDataService.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    // MARK: - Universities
    
    let mockUniversities: [University] = [
        University(
            id: "uw",
            name: "Uniwersytet Warszawski",
            shortName: "UW",
            type: .university,
            city: "Warszawa",
            voivodeship: "Mazowieckie",
            address: "Krakowskie Przedmieście 26/28",
            website: "https://www.uw.edu.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1562774053-701939374585?w=800",
            description: "Największy i najlepszy uniwersytet w Polsce",
            ranking: 1,
            isPublic: true,
            establishedYear: 1816,
            studentCount: 44000,
            programIds: ["uw-informatyka", "uw-prawo", "uw-psychologia"]
        ),
        University(
            id: "pw",
            name: "Politechnika Warszawska",
            shortName: "PW",
            type: .technical,
            city: "Warszawa",
            voivodeship: "Mazowieckie",
            address: "Wybrzeże Wyspiańskiego 27",
            website: "https://www.pw.edu.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=800",
            description: "Najlepsza uczelnia techniczna w Polsce",
            ranking: 2,
            isPublic: true,
            establishedYear: 1915,
            studentCount: 30000,
            programIds: ["pw-informatyka", "pw-elektronika", "pw-mechanika"]
        ),
        University(
            id: "uj",
            name: "Uniwersytet Jagielloński",
            shortName: "UJ",
            type: .university,
            city: "Kraków",
            voivodeship: "Małopolskie",
            address: "ul. Gołębia 24",
            website: "https://www.uj.edu.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1580537659466-0a9bfa916a54?w=800",
            description: "Najstarsza uczelnia w Polsce",
            ranking: 3,
            isPublic: true,
            establishedYear: 1364,
            studentCount: 35000,
            programIds: ["uj-medycyna", "uj-prawo", "uj-filologia"]
        ),
        University(
            id: "agh",
            name: "Akademia Górniczo-Hutnicza",
            shortName: "AGH",
            type: .technical,
            city: "Kraków",
            voivodeship: "Małopolskie",
            address: "al. Mickiewicza 30",
            website: "https://www.agh.edu.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1607237138185-eedd9c632b0b?w=800",
            description: "Wiodąca uczelnia techniczna",
            ranking: 4,
            isPublic: true,
            establishedYear: 1919,
            studentCount: 28000,
            programIds: ["agh-informatyka", "agh-automatyka", "agh-energetyka"]
        ),
        University(
            id: "sgh",
            name: "Szkoła Główna Handlowa",
            shortName: "SGH",
            type: .economic,
            city: "Warszawa",
            voivodeship: "Mazowieckie",
            address: "al. Niepodległości 10",
            website: "https://www.sgh.waw.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1519452575417-564c1401ecc0?w=800",
            description: "Najlepsza uczelnia ekonomiczna w Polsce",
            ranking: 5,
            isPublic: true,
            establishedYear: 1906,
            studentCount: 15000,
            programIds: ["sgh-ekonomia", "sgh-finanse", "sgh-zarzadzanie"]
        ),
        University(
            id: "asp",
            name: "Akademia Sztuk Pięknych w Warszawie",
            shortName: "ASP",
            type: .art,
            city: "Warszawa",
            voivodeship: "Mazowieckie",
            address: "Targ Węglowy 6",
            website: "https://www.asp.waw.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800",
            description: "Najstarsza i największa uczelnia artystyczna w Polsce",
            ranking: 1,
            isPublic: true,
            establishedYear: 1816,
            studentCount: 1200,
            programIds: ["asp-grafika", "asp-malarstwo", "asp-rzezba"]
        ),
        University(
            id: "awf",
            name: "Akademia Wychowania Fizycznego Józefa Piłsudskiego",
            shortName: "AWF",
            type: .sport,
            city: "Warszawa",
            voivodeship: "Mazowieckie",
            address: "ul. Mikołowska 72A",
            website: "https://www.awf.edu.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800",
            description: "Wiodąca uczelnia sportowa w Polsce",
            ranking: 1,
            isPublic: true,
            establishedYear: 1929,
            studentCount: 5000,
            programIds: ["awf-sport", "awf-fizjoterapia", "awf-turystyka"]
        ),
        University(
            id: "umcs",
            name: "Uniwersytet Marii Curie-Skłodowskiej",
            shortName: "UMCS",
            type: .university,
            city: "Lublin",
            voivodeship: "Lubelskie",
            address: "Plac Marii Curie-Skłodowskiej 5",
            website: "https://www.umcs.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1570554886111-e80fcca6a029?w=800",
            description: "Największa uczelnia we wschodniej Polsce",
            ranking: 8,
            isPublic: true,
            establishedYear: 1944,
            studentCount: 20000,
            programIds: []
        ),
        University(
            id: "uam",
            name: "Uniwersytet im. Adama Mickiewicza",
            shortName: "UAM",
            type: .university,
            city: "Poznań",
            voivodeship: "Wielkopolskie",
            address: "ul. Wieniawskiego 1",
            website: "https://www.amu.edu.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1592280771190-3e2e4d571952?w=800",
            description: "Jeden z najlepszych uniwersytetów w Polsce",
            ranking: 6,
            isPublic: true,
            establishedYear: 1919,
            studentCount: 35000,
            programIds: []
        ),
        University(
            id: "pwr",
            name: "Politechnika Łódzka",
            shortName: "PŁ",
            type: .technical,
            city: "Łódź",
            voivodeship: "Łódzkie",
            address: "ul. Żeromskiego 116",
            website: "https://www.p.lodz.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1581093450021-4a7360e9a6b5?w=800",
            description: "Wiodąca politechnika w centralnej Polsce",
            ranking: 7,
            isPublic: true,
            establishedYear: 1945,
            studentCount: 18000,
            programIds: []
        ),
        University(
            id: "us",
            name: "Uniwersytet Szczeciński",
            shortName: "US",
            type: .university,
            city: "Szczecin",
            voivodeship: "Zachodniopomorskie",
            address: "ul. Mickiewicza 64",
            website: "https://www.usz.edu.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1589330694653-ded6df03f754?w=800",
            description: "Największa uczelnia na Pomorzu Zachodnim",
            ranking: 12,
            isPublic: true,
            establishedYear: 1985,
            studentCount: 15000,
            programIds: []
        ),
        University(
            id: "pb",
            name: "Politechnika Białostocka",
            shortName: "PB",
            type: .technical,
            city: "Białystok",
            voivodeship: "Podlaskie",
            address: "ul. Wiejska 45A",
            website: "https://www.pb.edu.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1562774053-701939374585?w=800",
            description: "Nowoczesna uczelnia techniczna",
            ranking: 15,
            isPublic: true,
            establishedYear: 1949,
            studentCount: 10000,
            programIds: []
        )
    ]
    
    // MARK: - Study Programs
    
    let mockPrograms: [StudyProgram] = [
        // UW Programs
        StudyProgram(
            id: "uw-informatyka",
            universityId: "uw",
            name: "Informatyka",
            faculty: "Wydział Matematyki, Informatyki i Mechaniki",
            field: "Informatyka",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Program obejmuje zaawansowane algorytmy, struktury danych, programowanie obiektowe oraz sztuczną inteligencję. Studenci uczą się języków programowania takich jak Python, Java, C++ oraz technologii webowych. W trakcie studiów realizowane są projekty zespołowe oraz praktyki w firmach IT.",
            requirements: AdmissionRequirements(
                description: "Najlepsza ocena z egzaminu maturalnego z przedmiotów ścisłych (matematyka rozszerzona, informatyka rozszerzona) przemnożona przez współczynnik 0.5, plus wynik z matematyki rozszerzonej przemnożony przez 0.3, plus wynik z języka angielskiego na poziomie rozszerzonym przemnożony przez 0.2. W przypadku braku egzaminu z informatyki, może być zastąpiona fizyką rozszerzoną.",
                formula: FormulaFactory.createITFormula(universityId: "uw", programId: "uw-informatyka"),
                formulaId: "uw-informatyka-formula",
                minimumPoints: 80,
                additionalExams: [],
                documents: ["Świadectwo maturalne", "Podanie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 200,
            lastYearThreshold: 85.5,
            tags: ["AI", "Machine Learning", "Algorytmy"],
            imageURL: "https://images.unsplash.com/photo-1517430816045-df4b7de11d1d?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            thumbnailURL: "https://images.unsplash.com/photo-1517430816045-df4b7de11d1d?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            applicationURL: "https://irk.uw.edu.pl/kierunki/informatyka"
        ),
        StudyProgram(
            id: "uw-prawo",
            universityId: "uw",
            name: "Prawo",
            faculty: "Wydział Prawa i Administracji",
            field: "Prawo",
            degree: .unified,
            mode: .stationary,
            duration: 10,
            language: "Polski",
            description: "Program obejmuje prawo konstytucyjne, cywilne, karne, administracyjne oraz międzynarodowe. Studenci uczestniczą w symulacjach rozpraw sądowych i warsztatach z technik prawniczych. Studia przygotowują do egzaminów zawodowych na aplikacje prawnicze.",
            requirements: AdmissionRequirements(
                description: "Suma wyników procentowych z języka polskiego na poziomie rozszerzonym (waga 0.4) oraz historii rozszerzonej (waga 0.3) i wiedzy o społeczeństwie rozszerzonej (waga 0.3). Kandydaci mogą zastąpić jeden z przedmiotów humanistycznych językiem łacińskim lub filozofią.",
                formula: FormulaFactory.createLawFormula(universityId: "uw", programId: "uw-prawo"),
                formulaId: "uw-prawo-formula",
                minimumPoints: 75,
                additionalExams: [],
                documents: ["Świadectwo maturalne", "Podanie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 300,
            lastYearThreshold: 78.2,
            tags: ["Prawo karne", "Prawo cywilne", "Administracja"],
            imageURL: "https://images.unsplash.com/photo-1589994965851-a8f479c573a9?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1589994965851-a8f479c573a9?w=400",
            applicationURL: "https://irk.uw.edu.pl/kierunki/prawo"
        ),
        // PW Programs
        StudyProgram(
            id: "pw-informatyka",
            universityId: "pw",
            name: "Informatyka",
            field: "Informatyka",
            degree: .engineer,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Program łączy informatykę z inżynierią systemów, obejmując projektowanie oprogramowania, sieci komputerowe i systemy wbudowane. Studenci realizują projekty z cyberbezpieczeństwa, IoT oraz uczą się metodyk zarządzania projektami IT. Nacisk kładziony jest na praktyczne umiejętności inżynierskie.",
            requirements: AdmissionRequirements(
                description: "Wynik egzaminu z matematyki rozszerzonej stanowi 60% oceny końcowej, fizyka rozszerzona 30%, a język angielski na poziomie podstawowym 10%. Kandydaci z olimpiad przedmiotowych (matematyka, fizyka, informatyka) otrzymują maksymalną punktację.",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "pw",
                    programId: "pw-informatyka",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.6),
                        (subject: "FIZ", level: "R", weight: 0.3),
                        (subject: "ANG", level: "P", weight: 0.1)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 88.3
                ),
                formulaId: "pw-informatyka-formula",
                minimumPoints: 85,
                additionalExams: [],
                documents: ["Świadectwo maturalne", "Podanie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 250,
            lastYearThreshold: 88.3,
            tags: ["Cyberbezpieczeństwo", "IoT", "Systemy wbudowane"],
            applicationURL: "https://rekrutacja.pw.edu.pl/kierunki/informatyka"
        ),
        // UJ Programs
        StudyProgram(
            id: "uj-medycyna",
            universityId: "uj",
            name: "Kierunek lekarski",
            field: "Medycyna",
            degree: .unified,
            mode: .stationary,
            duration: 12,
            language: "Polski",
            description: "Program obejmuje anatomię, fizjologię, biochemię, farmakologię oraz przedmioty kliniczne. Studenci odbywają praktyki w szpitalach uniwersyteckich, ucząc się diagnostyki i leczenia. Ostatnie lata studiów poświęcone są specjalizacjom medycznym i przygotowaniu do LEK.",
            requirements: AdmissionRequirements(
                description: "Punktacja opiera się na wynikach z biologii rozszerzonej (40%), chemii rozszerzonej (40%) oraz matematyki rozszerzonej (20%). Dodatkowo kandydaci muszą zdać test predyspozycji zawodowych. Laureaci olimpiad biologicznych i chemicznych przyjmowani są poza limitem miejsc.",
                formula: FormulaFactory.createMedicineFormula(universityId: "uj", programId: "uj-medycyna"),
                formulaId: "uj-medycyna-formula",
                minimumPoints: 90,
                additionalExams: ["Test predyspozycji"],
                documents: ["Świadectwo maturalne", "Zaświadczenie lekarskie", "Podanie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .mixed,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 150,
            lastYearThreshold: 92.7,
            tags: ["Chirurgia", "Pediatria", "Kardiologia"],
            imageURL: "https://images.unsplash.com/photo-1581595220892-b0739db3ba8c?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1581595220892-b0739db3ba8c?w=400"
        ),
        // SGH Programs
        StudyProgram(
            id: "sgh-ekonomia",
            universityId: "sgh",
            name: "Ekonomia",
            field: "Ekonomia",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Program obejmuje mikroekonomię, makroekonomię, ekonometrię oraz finanse międzynarodowe. Studenci uczą się analizy rynków finansowych, zarządzania ryzykiem i modelowania ekonomicznego. Studia zawierają case studies z realnego biznesu oraz współpracę z przedsiębiorstwami.",
            requirements: AdmissionRequirements(
                description: "Rekrutacja uwzględnia wyniki z matematyki rozszerzonej (współczynnik 0.5), geografii rozszerzonej lub wiedzy o społeczeństwie (współczynnik 0.3) oraz języka angielskiego na poziomie rozszerzonym (współczynnik 0.2). Mile widziane są dodatkowe certyfikaty językowe.",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "sgh",
                    programId: "sgh-ekonomia",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.5),
                        (subject: "GEO", level: "R", weight: 0.3),
                        (subject: "ANG", level: "R", weight: 0.2)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 73.5
                ),
                formulaId: "sgh-ekonomia-formula",
                minimumPoints: 70,
                additionalExams: [],
                documents: ["Świadectwo maturalne", "Podanie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 400,
            lastYearThreshold: 73.5,
            tags: ["Makroekonomia", "Finanse", "Analiza rynków"]
        ),
        // AGH Programs
        StudyProgram(
            id: "agh-informatyka",
            universityId: "agh",
            name: "Informatyka",
            field: "Informatyka",
            degree: .engineer,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Program łączy informatykę teoretyczną z zastosowaniami w przemyśle, obejmując big data, uczenie maszynowe i robotykę. Studenci realizują projekty we współpracy z firmami technologicznymi oraz korzystają z nowoczesnych laboratoriów. Nacisk położony jest na rozwiązywanie rzeczywistych problemów inżynierskich.",
            requirements: AdmissionRequirements(
                description: "Proces rekrutacji uwzględnia wyniki z matematyki rozszerzonej (50% punktacji), informatyki rozszerzonej lub fizyki rozszerzonej (30% punktacji) oraz fizyki rozszerzonej lub chemii rozszerzonej (20% punktacji). Kandydaci mogą przedstawić certyfikaty ukończenia kursów programowania jako dodatkowe atuty.",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "agh",
                    programId: "agh-informatyka",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.5),
                        (subject: "INF", level: "R", weight: 0.3),
                        (subject: "FIZ", level: "R", weight: 0.2)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 84.0
                ),
                formulaId: "agh-informatyka-formula",
                minimumPoints: 82,
                additionalExams: [],
                documents: ["Świadectwo maturalne", "Podanie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 180,
            lastYearThreshold: 84.0,
            tags: ["Big Data", "Sztuczna inteligencja", "Robotyka"]
        ),
        // New program with nil threshold for testing
        StudyProgram(
            id: "uw-new-psychology",
            universityId: "uw",
            name: "Neuropsychologia kliniczna",
            faculty: "Wydział Psychologii",
            field: "Psychologia",
            degree: .master,
            mode: .stationary,
            duration: 4,
            language: "Polski",
            description: "Nowy kierunek łączący psychologię z neuronauką. Program obejmuje zaawansowane metody diagnostyki neuropsychologicznej, terapię pacjentów z uszkodzeniami mózgu oraz badania nad funkcjonowaniem poznawczym.",
            requirements: AdmissionRequirements(
                description: "Rekrutacja dla absolwentów psychologii lub kierunków pokrewnych. Wymagany jest dyplom licencjata z psychologii lub nauk kognitywnych. Rozmowa kwalifikacyjna obejmuje zagadnienia z neurobiologii i metod badawczych.",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "uw-new-psychology",
                    components: [],
                    mandatorySubjects: [],
                    lastYearThreshold: nil
                ),
                formulaId: "uw-new-psychology-formula",
                minimumPoints: nil,
                additionalExams: ["Rozmowa kwalifikacyjna"],
                documents: ["Dyplom licencjata", "Suplement do dyplomu", "CV", "List motywacyjny"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*60),
                admissionType: .interview,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 30,
            lastYearThreshold: nil, // No threshold data available for new program
            tags: ["Neuropsychologia", "Diagnostyka", "Terapia", "Badania mózgu"]
        ),
        // Film Directing in Łódź - Entrance Exam Required
        StudyProgram(
            id: "lodz-film-directing",
            universityId: "pw", // Using PW as placeholder for Łódź Film School
            name: "Reżyseria filmowa",
            faculty: "Wydział Reżyserii Filmowej i Telewizyjnej",
            field: "Sztuka",
            degree: .unified,
            mode: .stationary,
            duration: 10,
            language: "Polski",
            description: "Prestiżowy kierunek kształcący przyszłych reżyserów filmowych. Program obejmuje warsztaty z technik filmowych, historię kina, scenopisarstwo oraz realizację własnych projektów filmowych. Absolwenci pracują w kinematografii, telewizji i platformach streamingowych.",
            requirements: AdmissionRequirements(
                description: "Rekrutacja wieloetapowa obejmująca ocenę portfolio, egzaminy praktyczne i teoretyczne. Kandydaci przesyłają portfolio z własnymi pracami filmowymi lub scenariuszami. Egzamin praktyczny polega na realizacji krótkiej etiudy filmowej. Egzamin teoretyczny sprawdza wiedzę o kinie i kulturze.",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "pw",
                    programId: "lodz-film-directing",
                    components: [],
                    mandatorySubjects: [],
                    lastYearThreshold: nil
                ),
                formulaId: "lodz-film-directing-formula",
                minimumPoints: nil,
                additionalExams: ["Portfolio", "Egzamin praktyczny - realizacja etiudy", "Egzamin teoretyczny z historii kina", "Rozmowa kwalifikacyjna"],
                documents: ["Świadectwo maturalne", "Portfolio prac", "List motywacyjny", "CV artystyczne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*120),
                admissionType: .entranceExam,
                entranceExamDetails: EntranceExamDetails(
                    examType: "Egzamin praktyczny i teoretyczny",
                    stages: [
                        "Etap I: Ocena portfolio (prace filmowe, scenariusze, fotografie)",
                        "Etap II: Egzamin praktyczny - realizacja etiudy na zadany temat",
                        "Etap III: Egzamin teoretyczny z historii kina i analizy filmowej",
                        "Etap IV: Rozmowa kwalifikacyjna z komisją"
                    ],
                    description: "Egzamin sprawdza predyspozycje artystyczne, wyobraźnię twórczą oraz umiejętności techniczne. Kandydaci realizują krótką etiudę filmową na podstawie otrzymanego tematu, wykorzystując sprzęt udostępniony przez uczelnię.",
                    sampleTasksURL: "https://filmschool.lodz.pl/rekrutacja/przykladowe-zadania",
                    preparationTips: "Zalecamy obejrzenie klasycznych dzieł kina polskiego i światowego, praktykę w realizacji krótkich form filmowych oraz rozwijanie umiejętności pracy zespołowej."
                )
            ),
            tuitionFee: 0,
            availableSlots: 15,
            lastYearThreshold: nil, // No point threshold - entrance exam only
            tags: ["Reżyseria", "Film", "Kino", "Sztuka filmowa", "Scenariusz"],
            imageURL: "https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=800",
            applicationURL: "https://filmschool.lodz.pl/rekrutacja/reżyseria"
        ),
        // Architecture - Mixed admission (points + portfolio)
        StudyProgram(
            id: "pw-architecture",
            universityId: "pw",
            name: "Architektura",
            faculty: "Wydział Architektury",
            field: "Architektura",
            degree: .engineer,
            mode: .stationary,
            duration: 8,
            language: "Polski",
            description: "Program łączy sztukę z inżynierią, kształcąc architektów przygotowanych do projektowania przestrzeni miejskich i budynków. Studenci uczą się projektowania architektonicznego, urbanistyki, historii architektury oraz wykorzystania nowoczesnych technologii w projektowaniu.",
            requirements: AdmissionRequirements(
                description: "Rekrutacja dwuetapowa: punkty maturalne oraz egzamin z rysunku i kompozycji przestrzennej. Ocena z egzaminu maturalnego stanowi 50% wyniku końcowego, a egzamin wstępny 50%.",
                formula: FormulaFactory.createArchitectureFormula(universityId: "pw", programId: "pw-architecture"),
                formulaId: "pw-architecture-formula",
                minimumPoints: 70,
                additionalExams: ["Egzamin z rysunku odręcznego", "Test z wyobraźni przestrzennej"],
                documents: ["Świadectwo maturalne", "Podanie", "Portfolio prac plastycznych (opcjonalnie)"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .mixed,
                entranceExamDetails: EntranceExamDetails(
                    examType: "Egzamin z rysunku i wyobraźni przestrzennej",
                    stages: [
                        "Etap I: Weryfikacja punktów maturalnych",
                        "Etap II: Egzamin z rysunku odręcznego (martwa natura, perspektywa)",
                        "Etap III: Test wyobraźni przestrzennej i kompozycji"
                    ],
                    description: "Egzamin sprawdza umiejętności manualne, wyobraźnię przestrzenną oraz zmysł estetyczny. Kandydaci wykonują rysunek martwej natury oraz zadania z geometrii wykreślnej.",
                    sampleTasksURL: "https://arch.pw.edu.pl/rekrutacja/przykłady",
                    preparationTips: "Zalecamy uczestnictwo w kursach rysunku, ćwiczenie perspektywy i proporcji oraz zapoznanie się z podstawami geometrii wykreślnej."
                )
            ),
            tuitionFee: 0,
            availableSlots: 120,
            lastYearThreshold: 82.5,
            tags: ["Projektowanie", "Urbanistyka", "Rysunek techniczny", "CAD"],
            imageURL: "https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=800"
        ),
        // Medicine - Unknown admission criteria
        StudyProgram(
            id: "unknown-medicine-private",
            universityId: "uj",
            name: "Medycyna (studia anglojęzyczne)",
            faculty: "Wydział Lekarski",
            field: "Medycyna",
            degree: .unified,
            mode: .stationary,
            duration: 12,
            language: "Angielski",
            description: "6-letni program medyczny w języku angielskim dla studentów międzynarodowych i polskich. Program przygotowuje do międzynarodowej kariery lekarskiej z możliwością specjalizacji w wielu krajach.",
            requirements: AdmissionRequirements(
                description: "Szczegółowe kryteria rekrutacji nie zostały jeszcze opublikowane. Prosimy o regularne sprawdzanie strony uczelni lub kontakt z biurem rekrutacji.",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uj",
                    programId: "unknown-medicine-private",
                    components: [],
                    mandatorySubjects: [],
                    lastYearThreshold: nil
                ),
                formulaId: "unknown-medicine-private-formula",
                minimumPoints: nil,
                additionalExams: [],
                documents: ["Dokładna lista dokumentów zostanie opublikowana"],
                deadlineDate: nil,
                admissionType: .unknown,
                entranceExamDetails: nil
            ),
            tuitionFee: 15000, // per semester
            availableSlots: nil,
            lastYearThreshold: nil,
            tags: ["Medycyna", "Studia anglojęzyczne", "International", "Medicine"],
            imageURL: "https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=400",
            applicationURL: "https://medicine.uj.edu.pl/en/admission"
        ),
        // Music Academy - Portfolio based
        StudyProgram(
            id: "academy-music-piano",
            universityId: "uw", // Placeholder for Music Academy
            name: "Instrumentalistyka - Fortepian",
            faculty: "Wydział Fortepianu, Klawesynu i Organów",
            field: "Sztuka",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Kształcenie profesjonalnych pianistów na najwyższym poziomie artystycznym. Program obejmuje indywidualne lekcje z mistrzami fortepianu, występy publiczne oraz teoretyczne podstawy muzyki.",
            requirements: AdmissionRequirements(
                description: "Rekrutacja oparta na przesłuchaniach. Kandydaci wykonują program obejmujący utwory z różnych epok, w tym etiudę koncertową, sonatę klasyczną oraz utwór dowolny.",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "academy-music-piano",
                    components: [],
                    mandatorySubjects: [],
                    lastYearThreshold: nil
                ),
                formulaId: "academy-music-piano-formula",
                minimumPoints: nil,
                additionalExams: ["Przesłuchanie - program 45 minut", "Egzamin z kształcenia słuchu", "Egzamin z harmonii"],
                documents: ["Świadectwo maturalne", "CV artystyczne", "Lista repertuaru", "Nagrania (opcjonalnie)"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .portfolio,
                entranceExamDetails: EntranceExamDetails(
                    examType: "Przesłuchanie",
                    stages: [
                        "Etap I: Przesłuchanie wstępne - program 20 minut",
                        "Etap II: Przesłuchanie główne - pełny program koncertowy",
                        "Etap III: Egzaminy teoretyczne (kształcenie słuchu, harmonia)"
                    ],
                    description: "Kandydaci prezentują zróżnicowany repertuar demonstrując technikę, interpretację i muzykalność. Wymagane utwory: etiuda koncertowa (Chopin, Liszt), sonata klasyczna (Haydn, Mozart, Beethoven), utwór romantyczny, utwór XX/XXI wieku.",
                    sampleTasksURL: nil,
                    preparationTips: "Przygotuj program starannie, zwracając uwagę na stylistykę wykonawczą każdej epoki. Ćwicz regularnie z akompaniatorem."
                )
            ),
            tuitionFee: 0,
            availableSlots: 8,
            lastYearThreshold: nil,
            tags: ["Fortepian", "Muzyka klasyczna", "Koncerty", "Sztuka"],
            imageURL: "https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=400"
        ),
        
        // Additional 20 programs with working images
        
        // 1. Biotechnology
        StudyProgram(
            id: "uw-biotechnology",
            universityId: "uw",
            name: "Biotechnologia",
            faculty: "Wydział Biologii",
            field: "Biotechnologia",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Interdyscyplinarne studia łączące biologię molekularną, genetykę i technologie przemysłowe",
            requirements: AdmissionRequirements(
                description: "Rekrutacja na podstawie wyników matury z biologii i chemii",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "uw-biotechnology",
                    components: [
                        (subject: "BIO", level: "R", weight: 0.4),
                        (subject: "CHEM", level: "R", weight: 0.4),
                        (subject: "MAT", level: "P", weight: 0.2)
                    ],
                    mandatorySubjects: ["BIO", "CHEM"],
                    lastYearThreshold: 78.3
                ),
                formulaId: "uw-biotechnology-formula",
                minimumPoints: 75,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 60,
            lastYearThreshold: 78.3,
            tags: ["Genetyka", "Laboratoria", "Przemysł farmaceutyczny"],
            imageURL: "https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1582719508461-905c673771fd?w=400"
        ),
        
        // 2. Data Science
        StudyProgram(
            id: "pw-data-science",
            universityId: "pw",
            name: "Data Science",
            faculty: "Wydział Matematyki i Nauk Informacyjnych",
            field: "Data Science",
            degree: .bachelor,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Analiza danych, uczenie maszynowe i big data",
            requirements: AdmissionRequirements(
                description: "Wymagana matematyka rozszerzona i informatyka lub fizyka",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "pw",
                    programId: "pw-data-science",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.5),
                        (subject: "INF", level: "R", weight: 0.3),
                        (subject: "ANG", level: "P", weight: 0.2)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 82.7
                ),
                formulaId: "pw-data-science-formula",
                minimumPoints: 80,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 90,
            lastYearThreshold: 82.7,
            tags: ["AI", "Big Data", "Python", "Machine Learning"],
            imageURL: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400"
        ),
        
        // 3. Veterinary Medicine
        StudyProgram(
            id: "sggw-veterinary",
            universityId: "uw",
            name: "Weterynaria",
            faculty: "Wydział Medycyny Weterynaryjnej",
            field: "Weterynaria",
            degree: .unified,
            mode: .stationary,
            duration: 11,
            language: "Polski",
            description: "Studia przygotowujące do pracy jako lekarz weterynarii",
            requirements: AdmissionRequirements(
                description: "Wymagane przedmioty: biologia i chemia rozszerzone",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "sggw-veterinary",
                    components: [
                        (subject: "BIO", level: "R", weight: 0.4),
                        (subject: "CHEM", level: "R", weight: 0.4),
                        (subject: "POL", level: "P", weight: 0.2)
                    ],
                    mandatorySubjects: ["BIO", "CHEM"],
                    lastYearThreshold: 88.2
                ),
                formulaId: "sggw-veterinary-formula",
                minimumPoints: 85,
                additionalExams: [],
                documents: ["Świadectwo maturalne", "Zaświadczenie lekarskie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 100,
            lastYearThreshold: 88.2,
            tags: ["Medycyna", "Zwierzęta", "Chirurgia"],
            imageURL: "https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=400"
        ),
        
        // 4. International Relations
        StudyProgram(
            id: "uw-international-relations",
            universityId: "uw",
            name: "Stosunki międzynarodowe",
            faculty: "Wydział Nauk Politycznych i Studiów Międzynarodowych",
            field: "Stosunki międzynarodowe",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Polityka międzynarodowa, dyplomacja i organizacje międzynarodowe",
            requirements: AdmissionRequirements(
                description: "Punkty z historii, WOS-u lub geografii",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "uw-international-relations",
                    components: [
                        (subject: "HIS", level: "P", weight: 0.4),
                        (subject: "WOS", level: "P", weight: 0.3),
                        (subject: "J.OBC", level: "R", weight: 0.3)
                    ],
                    mandatorySubjects: [],
                    lastYearThreshold: 73.5
                ),
                formulaId: "uw-international-relations-formula",
                minimumPoints: 70,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 150,
            lastYearThreshold: 73.5,
            tags: ["Dyplomacja", "ONZ", "Unia Europejska"],
            imageURL: "https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=400"
        ),
        
        // 5. Fashion Design
        StudyProgram(
            id: "asp-fashion",
            universityId: "asp",
            name: "Projektowanie mody",
            faculty: "Wydział Wzornictwa",
            field: "Wzornictwo",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Projektowanie ubioru, tkanin i akcesoriów modowych",
            requirements: AdmissionRequirements(
                description: "Egzamin praktyczny z rysunku i projektowania",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "asp",
                    programId: "asp-fashion",
                    components: [],
                    mandatorySubjects: [],
                    lastYearThreshold: nil
                ),
                formulaId: "asp-fashion-formula",
                minimumPoints: nil,
                additionalExams: ["Egzamin z rysunku", "Projekt kolekcji", "Portfolio"],
                documents: ["Świadectwo maturalne", "Portfolio prac"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .portfolio,
                entranceExamDetails: EntranceExamDetails(
                    examType: "Egzamin praktyczny",
                    stages: ["Portfolio", "Rysunek postaci", "Projekt kolekcji"],
                    description: "Trzystopniowy egzamin sprawdzający zdolności projektowe",
                    sampleTasksURL: nil,
                    preparationTips: "Przygotuj portfolio pokazujące różnorodność technik"
                )
            ),
            tuitionFee: 0,
            availableSlots: 30,
            lastYearThreshold: nil,
            tags: ["Moda", "Design", "Kreacja"],
            imageURL: "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=400"
        ),
        
        // 6. Environmental Engineering
        StudyProgram(
            id: "pw-environmental",
            universityId: "pw",
            name: "Inżynieria środowiska",
            faculty: "Wydział Instalacji Budowlanych, Hydrotechniki i Inżynierii Środowiska",
            field: "Inżynieria środowiska",
            degree: .engineer,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Ochrona środowiska, oczyszczanie wody i powietrza, energia odnawialna",
            requirements: AdmissionRequirements(
                description: "Matematyka i fizyka lub chemia",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "pw",
                    programId: "pw-environmental",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.4),
                        (subject: "FIZ", level: "P", weight: 0.3),
                        (subject: "CHEM", level: "P", weight: 0.3)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 68.4
                ),
                formulaId: "pw-environmental-formula",
                minimumPoints: 65,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 120,
            lastYearThreshold: 68.4,
            tags: ["Ekologia", "OZE", "Klimat"],
            imageURL: "https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400"
        ),
        
        // 7. Physiotherapy
        StudyProgram(
            id: "awf-physiotherapy",
            universityId: "awf",
            name: "Fizjoterapia",
            faculty: "Wydział Rehabilitacji",
            field: "Fizjoterapia",
            degree: .unified,
            mode: .stationary,
            duration: 10,
            language: "Polski",
            description: "Kompleksowe studia przygotowujące do zawodu fizjoterapeuty",
            requirements: AdmissionRequirements(
                description: "Biologia i test sprawności fizycznej",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "awf",
                    programId: "awf-physiotherapy",
                    components: [
                        (subject: "BIO", level: "P", weight: 0.5),
                        (subject: "POL", level: "P", weight: 0.2)
                    ],
                    mandatorySubjects: ["BIO"],
                    lastYearThreshold: 74.8
                ),
                formulaId: "awf-physiotherapy-formula",
                minimumPoints: 70,
                additionalExams: ["Test sprawności fizycznej"],
                documents: ["Świadectwo maturalne", "Zaświadczenie lekarskie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .mixed,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 80,
            lastYearThreshold: 74.8,
            tags: ["Rehabilitacja", "Medycyna sportowa", "Masaż"],
            imageURL: "https://images.unsplash.com/photo-1559034750-cdab70a66b8e?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1559034750-cdab70a66b8e?w=400"
        ),
        
        // 8. Game Development
        StudyProgram(
            id: "pw-game-dev",
            universityId: "pw",
            name: "Projektowanie gier i aplikacji mobilnych",
            faculty: "Wydział Elektroniki i Technik Informacyjnych",
            field: "Informatyka",
            degree: .engineer,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Unity, Unreal Engine, projektowanie rozgrywki i grafiki",
            requirements: AdmissionRequirements(
                description: "Matematyka i informatyka",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "pw",
                    programId: "pw-game-dev",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.5),
                        (subject: "INF", level: "R", weight: 0.4),
                        (subject: "ANG", level: "P", weight: 0.1)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 79.2
                ),
                formulaId: "pw-game-dev-formula",
                minimumPoints: 75,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 60,
            lastYearThreshold: 79.2,
            tags: ["Unity", "GameDev", "VR/AR", "Mobile"],
            imageURL: "https://images.unsplash.com/photo-1556438064-2d7646166914?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1556438064-2d7646166914?w=400"
        ),
        
        // 9. Journalism
        StudyProgram(
            id: "uw-journalism",
            universityId: "uw",
            name: "Dziennikarstwo i medioznawstwo",
            faculty: "Wydział Dziennikarstwa, Informacji i Bibliologii",
            field: "Dziennikarstwo",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Media tradycyjne i cyfrowe, dziennikarstwo śledcze, PR",
            requirements: AdmissionRequirements(
                description: "Polski i historia lub WOS",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "uw-journalism",
                    components: [
                        (subject: "POL", level: "R", weight: 0.4),
                        (subject: "HIS", level: "P", weight: 0.3),
                        (subject: "WOS", level: "P", weight: 0.3)
                    ],
                    mandatorySubjects: ["POL"],
                    lastYearThreshold: 69.7
                ),
                formulaId: "uw-journalism-formula",
                minimumPoints: 65,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 100,
            lastYearThreshold: 69.7,
            tags: ["Media", "TV", "Radio", "Internet"],
            imageURL: "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400"
        ),
        
        // 10. Aerospace Engineering
        StudyProgram(
            id: "pw-aerospace",
            universityId: "pw",
            name: "Lotnictwo i kosmonautyka",
            faculty: "Wydział Mechaniczny Energetyki i Lotnictwa",
            field: "Lotnictwo",
            degree: .engineer,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Projektowanie samolotów, dronów i technologii kosmicznych",
            requirements: AdmissionRequirements(
                description: "Matematyka i fizyka rozszerzone",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "pw",
                    programId: "pw-aerospace",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.5),
                        (subject: "FIZ", level: "R", weight: 0.4),
                        (subject: "ANG", level: "P", weight: 0.1)
                    ],
                    mandatorySubjects: ["MAT", "FIZ"],
                    lastYearThreshold: 87.9
                ),
                formulaId: "pw-aerospace-formula",
                minimumPoints: 85,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 50,
            lastYearThreshold: 87.9,
            tags: ["Samoloty", "Drony", "Kosmos", "NASA"],
            imageURL: "https://images.unsplash.com/photo-1610296669228-602fa827fc1f?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1610296669228-602fa827fc1f?w=400"
        ),
        
        // 11. Culinary Arts
        StudyProgram(
            id: "sggw-culinary",
            universityId: "sgh",
            name: "Gastronomia i sztuka kulinarna",
            faculty: "Wydział Nauk o Żywieniu Człowieka",
            field: "Gastronomia",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Zarządzanie gastronomią, technologia żywności, kulinaria",
            requirements: AdmissionRequirements(
                description: "Chemia lub biologia",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "sgh",
                    programId: "sggw-culinary",
                    components: [
                        (subject: "CHEM", level: "P", weight: 0.5),
                        (subject: "BIO", level: "P", weight: 0.3),
                        (subject: "POL", level: "P", weight: 0.2)
                    ],
                    mandatorySubjects: [],
                    lastYearThreshold: 62.3
                ),
                formulaId: "sggw-culinary-formula",
                minimumPoints: 60,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 70,
            lastYearThreshold: 62.3,
            tags: ["Kuchnia", "Restauracje", "Food design"],
            imageURL: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400"
        ),
        
        // 12. Interior Design
        StudyProgram(
            id: "asp-interior",
            universityId: "asp",
            name: "Architektura wnętrz",
            faculty: "Wydział Architektury Wnętrz",
            field: "Architektura wnętrz",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Projektowanie przestrzeni mieszkalnych i komercyjnych",
            requirements: AdmissionRequirements(
                description: "Egzamin z rysunku i projektu",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "asp",
                    programId: "asp-interior",
                    components: [],
                    mandatorySubjects: [],
                    lastYearThreshold: nil
                ),
                formulaId: "asp-interior-formula",
                minimumPoints: nil,
                additionalExams: ["Rysunek", "Projekt wnętrza", "Portfolio"],
                documents: ["Świadectwo maturalne", "Portfolio"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .portfolio,
                entranceExamDetails: EntranceExamDetails(
                    examType: "Egzamin praktyczny",
                    stages: ["Rysunek", "Projekt", "Rozmowa"],
                    description: "Egzamin sprawdzający zdolności przestrzenne",
                    sampleTasksURL: nil,
                    preparationTips: "Ćwicz perspektywę i kompozycję przestrzenną"
                )
            ),
            tuitionFee: 0,
            availableSlots: 35,
            lastYearThreshold: nil,
            tags: ["Design", "Wnętrza", "3D"],
            imageURL: "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=400"
        ),
        
        // 13. Renewable Energy
        StudyProgram(
            id: "agh-renewable",
            universityId: "agh",
            name: "Energetyka odnawialna",
            faculty: "Wydział Energetyki i Paliw",
            field: "Energetyka",
            degree: .engineer,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Fotowoltaika, energia wiatrowa, wodorowa i geotermalna",
            requirements: AdmissionRequirements(
                description: "Matematyka i fizyka",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "agh",
                    programId: "agh-renewable",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.5),
                        (subject: "FIZ", level: "R", weight: 0.4),
                        (subject: "CHEM", level: "P", weight: 0.1)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 72.6
                ),
                formulaId: "agh-renewable-formula",
                minimumPoints: 70,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 90,
            lastYearThreshold: 72.6,
            tags: ["Fotowoltaika", "Turbiny wiatrowe", "Zielona energia"],
            imageURL: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=400"
        ),
        
        // 14. Sports Management
        StudyProgram(
            id: "awf-management",
            universityId: "awf",
            name: "Zarządzanie sportem",
            faculty: "Wydział Wychowania Fizycznego",
            field: "Sport",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Marketing sportowy, organizacja imprez, zarządzanie klubami",
            requirements: AdmissionRequirements(
                description: "Matura i test sprawności",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "awf",
                    programId: "awf-management",
                    components: [
                        (subject: "POL", level: "P", weight: 0.4),
                        (subject: "MAT", level: "P", weight: 0.3)
                    ],
                    mandatorySubjects: [],
                    lastYearThreshold: 67.8
                ),
                formulaId: "awf-management-formula",
                minimumPoints: 65,
                additionalExams: ["Test sprawności fizycznej"],
                documents: ["Świadectwo maturalne", "Zaświadczenie lekarskie"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .mixed,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 60,
            lastYearThreshold: 67.8,
            tags: ["Marketing sportowy", "Eventy", "Sponsoring"],
            imageURL: "https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400"
        ),
        
        // 15. Cybersecurity
        StudyProgram(
            id: "pw-cybersecurity",
            universityId: "pw",
            name: "Cyberbezpieczeństwo",
            faculty: "Wydział Elektroniki i Technik Informacyjnych",
            field: "Informatyka",
            degree: .bachelor,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Bezpieczeństwo sieci, kryptografia, ethical hacking",
            requirements: AdmissionRequirements(
                description: "Matematyka i informatyka rozszerzone",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "pw",
                    programId: "pw-cybersecurity",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.5),
                        (subject: "INF", level: "R", weight: 0.4),
                        (subject: "ANG", level: "P", weight: 0.1)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 83.4
                ),
                formulaId: "pw-cybersecurity-formula",
                minimumPoints: 80,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 80,
            lastYearThreshold: 83.4,
            tags: ["Security", "Hacking", "Pentest", "SOC"],
            imageURL: "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=400"
        ),
        
        // 16. Animation
        StudyProgram(
            id: "asp-animation",
            universityId: "asp",
            name: "Animacja",
            faculty: "Wydział Grafiki",
            field: "Sztuka",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Animacja 2D, 3D, motion graphics, efekty specjalne",
            requirements: AdmissionRequirements(
                description: "Portfolio i egzamin praktyczny",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "asp",
                    programId: "asp-animation",
                    components: [],
                    mandatorySubjects: [],
                    lastYearThreshold: nil
                ),
                formulaId: "asp-animation-formula",
                minimumPoints: nil,
                additionalExams: ["Portfolio", "Projekt animacji", "Rysunek"],
                documents: ["Świadectwo maturalne", "Portfolio prac"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .portfolio,
                entranceExamDetails: EntranceExamDetails(
                    examType: "Egzamin praktyczny",
                    stages: ["Portfolio", "Animacja poklatkowa", "Storyboard"],
                    description: "Egzamin sprawdza umiejętności animacyjne",
                    sampleTasksURL: nil,
                    preparationTips: "Przygotuj showreel z własnymi animacjami"
                )
            ),
            tuitionFee: 0,
            availableSlots: 25,
            lastYearThreshold: nil,
            tags: ["3D", "Motion Graphics", "Pixar", "Disney"],
            imageURL: "https://images.unsplash.com/photo-1593073862407-a3ce22748763?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1593073862407-a3ce22748763?w=400"
        ),
        
        // 17. Social Work
        StudyProgram(
            id: "uw-social-work",
            universityId: "uw",
            name: "Praca socjalna",
            faculty: "Wydział Stosowanych Nauk Społecznych",
            field: "Praca socjalna",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Pomoc społeczna, interwencja kryzysowa, polityka społeczna",
            requirements: AdmissionRequirements(
                description: "Polski i WOS lub historia",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "uw-social-work",
                    components: [
                        (subject: "POL", level: "P", weight: 0.4),
                        (subject: "WOS", level: "P", weight: 0.3),
                        (subject: "HIS", level: "P", weight: 0.3)
                    ],
                    mandatorySubjects: ["POL"],
                    lastYearThreshold: 58.2
                ),
                formulaId: "uw-social-work-formula",
                minimumPoints: 55,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 80,
            lastYearThreshold: 58.2,
            tags: ["Pomoc społeczna", "NGO", "Interwencja"],
            imageURL: "https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=400"
        ),
        
        // 18. Criminology
        StudyProgram(
            id: "uw-criminology",
            universityId: "uw",
            name: "Kryminologia",
            faculty: "Wydział Stosowanych Nauk Społecznych i Resocjalizacji",
            field: "Kryminologia",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Interdyscyplinarne studia łączące prawo, psychologię i socjologię. Program obejmuje kryminalistykę, wiktymologię, profilowanie kryminalne oraz systemy penitencjarne. Absolwenci pracują w policji, służbach specjalnych, wymiarze sprawiedliwości i instytucjach resocjalizacyjnych.",
            requirements: AdmissionRequirements(
                description: "Wyniki z języka polskiego, WOS-u lub historii oraz matematyki podstawowej",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "uw-criminology",
                    components: [
                        (subject: "POL", level: "P", weight: 0.4),
                        (subject: "WOS", level: "P", weight: 0.3),
                        (subject: "MAT", level: "P", weight: 0.3)
                    ],
                    mandatorySubjects: ["POL"],
                    lastYearThreshold: 65.3
                ),
                formulaId: "uw-criminology-formula",
                minimumPoints: 60,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 100,
            lastYearThreshold: 65.3,
            tags: ["Kryminalistyka", "Profilowanie", "Policja", "Bezpieczeństwo"],
            imageURL: "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400"
        ),
        
        // 19. Robotics
        StudyProgram(
            id: "pw-robotics",
            universityId: "pw",
            name: "Robotyka",
            faculty: "Wydział Mechaniczny Energetyki i Lotnictwa",
            field: "Robotyka",
            degree: .engineer,
            mode: .stationary,
            duration: 7,
            language: "Polski",
            description: "Projektowanie robotów, automatyka, sztuczna inteligencja",
            requirements: AdmissionRequirements(
                description: "Matematyka, fizyka i informatyka",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "pw",
                    programId: "pw-robotics",
                    components: [
                        (subject: "MAT", level: "R", weight: 0.4),
                        (subject: "FIZ", level: "R", weight: 0.3),
                        (subject: "INF", level: "P", weight: 0.3)
                    ],
                    mandatorySubjects: ["MAT"],
                    lastYearThreshold: 81.5
                ),
                formulaId: "pw-robotics-formula",
                minimumPoints: 78,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 70,
            lastYearThreshold: 81.5,
            tags: ["Boston Dynamics", "AI", "Automatyka", "IoT"],
            imageURL: "https://images.unsplash.com/photo-1561557944-6e7860d1a7eb?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1561557944-6e7860d1a7eb?w=400"
        ),
        
        // 19. Dentistry
        StudyProgram(
            id: "uj-dentistry",
            universityId: "uj",
            name: "Stomatologia",
            faculty: "Wydział Lekarski",
            field: "Stomatologia",
            degree: .unified,
            mode: .stationary,
            duration: 10,
            language: "Polski",
            description: "Studia przygotowujące do zawodu lekarza dentysty",
            requirements: AdmissionRequirements(
                description: "Biologia, chemia i fizyka lub matematyka",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uj",
                    programId: "uj-dentistry",
                    components: [
                        (subject: "BIO", level: "R", weight: 0.4),
                        (subject: "CHEM", level: "R", weight: 0.4),
                        (subject: "FIZ", level: "P", weight: 0.2)
                    ],
                    mandatorySubjects: ["BIO", "CHEM"],
                    lastYearThreshold: 92.1
                ),
                formulaId: "uj-dentistry-formula",
                minimumPoints: 90,
                additionalExams: [],
                documents: ["Świadectwo maturalne"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .maturaPoints,
                entranceExamDetails: nil
            ),
            tuitionFee: 0,
            availableSlots: 60,
            lastYearThreshold: 92.1,
            tags: ["Medycyna", "Chirurgia", "Ortodoncja"],
            imageURL: "https://images.unsplash.com/photo-1609207825181-52d3214556dd?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1609207825181-52d3214556dd?w=400"
        ),
        
        // 20. Music Production
        StudyProgram(
            id: "uw-music-production",
            universityId: "uw",
            name: "Realizacja dźwięku",
            faculty: "Wydział Kultury i Sztuki",
            field: "Muzyka",
            degree: .bachelor,
            mode: .stationary,
            duration: 6,
            language: "Polski",
            description: "Produkcja muzyczna, nagrania studyjne, postprodukcja",
            requirements: AdmissionRequirements(
                description: "Egzamin praktyczny ze słuchu i wiedzy muzycznej",
                formula: FormulaFactory.createSimpleFormula(
                    universityId: "uw",
                    programId: "uw-music-production",
                    components: [],
                    mandatorySubjects: [],
                    lastYearThreshold: nil
                ),
                formulaId: "uw-music-production-formula",
                minimumPoints: nil,
                additionalExams: ["Test słuchu", "Teoria muzyki", "Portfolio nagrań"],
                documents: ["Świadectwo maturalne", "Portfolio"],
                deadlineDate: Date(timeIntervalSinceNow: 60*60*24*90),
                admissionType: .entranceExam,
                entranceExamDetails: EntranceExamDetails(
                    examType: "Egzamin praktyczny",
                    stages: ["Test słuchu muzycznego", "Egzamin z teorii", "Prezentacja portfolio"],
                    description: "Sprawdzenie predyspozycji muzycznych i technicznych",
                    sampleTasksURL: nil,
                    preparationTips: "Przygotuj nagrania własnych produkcji"
                )
            ),
            tuitionFee: 0,
            availableSlots: 40,
            lastYearThreshold: nil,
            tags: ["Studio", "DAW", "Mixing", "Mastering"],
            imageURL: "https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=800",
            thumbnailURL: "https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=400"
        )
    ]
    
    // MARK: - Erasmus Programs
    
    let mockErasmusPrograms: [ErasmusProgram] = [
        ErasmusProgram(
            id: "erasmus-uw-barcelona",
            universityId: "uw",
            partnerUniversity: "Universitat de Barcelona",
            country: "Hiszpania",
            city: "Barcelona",
            field: "Informatyka",
            availableForDegrees: [.bachelor, .master],
            duration: "1 semestr",
            language: "Angielski",
            requirements: ErasmusRequirements(
                minimumYear: 2,
                minimumGPA: 4.0,
                languageRequirement: "B2",
                languageCertificate: "TOEFL, IELTS lub certyfikat uczelni",
                additionalDocuments: ["CV", "List motywacyjny", "Transcript ocen"]
            ),
            deadline: Date(timeIntervalSinceNow: 60*60*24*120),
            availableSlots: 5,
            monthlyGrant: 500,
            description: "Wymiana z prestiżową uczelnią w Barcelonie",
            benefits: ["Międzynarodowe doświadczenie", "Nauka w języku angielskim", "Dostęp do nowoczesnych laboratoriów"]
        ),
        ErasmusProgram(
            id: "erasmus-pw-munich",
            universityId: "pw",
            partnerUniversity: "Technische Universität München",
            country: "Niemcy",
            city: "Monachium",
            field: "Inżynieria",
            availableForDegrees: [.engineer, .master],
            duration: "2 semestry",
            language: "Angielski/Niemiecki",
            requirements: ErasmusRequirements(
                minimumYear: 3,
                minimumGPA: 4.2,
                languageRequirement: "B2",
                languageCertificate: "TestDaF lub certyfikat uczelni",
                additionalDocuments: ["Portfolio projektów", "List motywacyjny", "Rekomendacje"]
            ),
            deadline: Date(timeIntervalSinceNow: 60*60*24*150),
            availableSlots: 3,
            monthlyGrant: 600,
            description: "Studia na jednej z najlepszych politechnik w Europie",
            benefits: ["Praktyki w niemieckich firmach", "Nowoczesne laboratoria", "Kursy języka niemieckiego"]
        )
    ]
    
    // MARK: - Sample Matura Scores
    
    func sampleMaturaScores() -> MaturaScores {
        var scores = MaturaScores()
        scores.subjects = [
            // Mandatory subjects
            MaturaSubjectScore(subject: .polish, level: .basic, scorePercentage: 85),
            MaturaSubjectScore(subject: .polish, level: .extended, scorePercentage: 72),
            MaturaSubjectScore(subject: .mathematics, level: .basic, scorePercentage: 78),
            MaturaSubjectScore(subject: .mathematics, level: .extended, scorePercentage: 68),
            MaturaSubjectScore(subject: .english, level: .basic, scorePercentage: 92),
            MaturaSubjectScore(subject: .english, level: .extended, scorePercentage: 88),
            // Additional subjects
            MaturaSubjectScore(subject: .physics, level: .extended, scorePercentage: 65),
            MaturaSubjectScore(subject: .computerScience, level: .extended, scorePercentage: 88)
        ]
        return scores
    }
}
