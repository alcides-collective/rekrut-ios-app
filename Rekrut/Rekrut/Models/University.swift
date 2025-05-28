//
//  University.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

struct University: Codable, Identifiable {
    let id: String
    var name: String
    var shortName: String?
    var type: UniversityType
    var city: String
    var voivodeship: String
    var address: String
    var website: String?
    var logoURL: String?
    var imageURL: String? // Background image for cards
    var description: String?
    var ranking: Int?
    var isPublic: Bool
    var establishedYear: Int?
    var studentCount: Int?
    var programIds: [String] // Study program IDs
    
    var displayName: String {
        shortName ?? name
    }
}

enum UniversityType: String, Codable, CaseIterable {
    case university = "Uniwersytet"
    case technical = "Politechnika"
    case economic = "Ekonomiczna"
    case medical = "Medyczna"
    case agricultural = "Rolnicza"
    case pedagogical = "Pedagogiczna"
    case arts = "Artystyczna"
    case military = "Wojskowa"
    case other = "Inna"
}