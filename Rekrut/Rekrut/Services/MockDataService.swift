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
            address: "Plac Politechniki 1",
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
            address: "al. Niepodległości 162",
            website: "https://www.sgh.waw.pl",
            logoURL: nil,
            imageURL: "https://images.unsplash.com/photo-1519452575417-564c1401ecc0?w=800",
            description: "Najlepsza uczelnia ekonomiczna w Polsce",
            ranking: 5,
            isPublic: true,
            establishedYear: 1906,
            studentCount: 15000,
            programIds: ["sgh-ekonomia", "sgh-finanse", "sgh-zarzadzanie"]
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
                formula: "W = 0.5 * MAT_R + 0.3 * INF_R + 0.2 * ANG_R",
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
                formula: "W = 0.4 * POL_R + 0.3 * HIS_R + 0.3 * WOS_R",
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
                formula: "W = 0.6 * MAT_R + 0.3 * FIZ_R + 0.1 * ANG_P",
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
                formula: "W = 0.4 * BIO_R + 0.4 * CHE_R + 0.2 * MAT_R",
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
            tags: ["Chirurgia", "Pediatria", "Kardiologia"]
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
                formula: "W = 0.5 * MAT_R + 0.3 * GEO_R + 0.2 * ANG_R",
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
                formula: "W = 0.5 * MAT_R + 0.3 * INF_R + 0.2 * FIZ_R",
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
                formula: "Średnia ze studiów I stopnia * 10 + punkty za rozmowę kwalifikacyjną",
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
                formula: "Ocena portfolio (40%) + Egzamin praktyczny (40%) + Egzamin teoretyczny (20%)",
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
                formula: "W = 0.5 * (0.4 * MAT_R + 0.3 * FIZ_R + 0.3 * J.OBC_R) + 0.5 * Egzamin_rysunku",
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
                formula: "Brak informacji",
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
                formula: "Ocena przesłuchania przez komisję",
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
            tags: ["Fortepian", "Muzyka klasyczna", "Koncerty", "Sztuka"]
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
