//
//  FirebaseService.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class FirebaseService: ObservableObject {
    static let shared = FirebaseService()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let realtimeDb = Database.database()
    private let storage = Storage.storage()
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private init() {
        checkAuthStatus()
    }
    
    // MARK: - Authentication
    
    private func checkAuthStatus() {
        _ = auth.addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
            if let user = user {
                self?.fetchUserData(userId: user.uid)
            } else {
                self?.currentUser = nil
            }
        }
    }
    
    func signInWithApple(credential: AuthCredential, fullName: PersonNameComponents?, email: String?) async throws {
        let result = try await auth.signIn(with: credential)
        
        // Check if this is a new user
        let isNewUser = result.additionalUserInfo?.isNewUser ?? false
        
        if isNewUser {
            // Create user profile for new Apple ID users
            var displayName = result.user.displayName
            
            // If display name is not provided by Firebase, construct it from PersonNameComponents
            if displayName == nil, let fullName = fullName {
                let formatter = PersonNameComponentsFormatter()
                displayName = formatter.string(from: fullName)
            }
            
            var newUser = User(id: result.user.uid, email: email ?? result.user.email ?? "")
            newUser.displayName = displayName
            
            try await saveUser(newUser)
            currentUser = newUser
        } else {
            // Existing user - just fetch their data
            fetchUserData(userId: result.user.uid)
        }
        
        // Sync local matura scores to Firebase after sign in
        await LocalStorageService.shared.syncMaturaScoresWithFirebase()
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    // MARK: - User Data
    
    private func fetchUserData(userId: String) {
        Task {
            do {
                let document = try await db.collection("users").document(userId).getDocument()
                if let data = document.data() {
                    let user = try Firestore.Decoder().decode(User.self, from: data)
                    await MainActor.run {
                        self.currentUser = user
                    }
                }
            } catch {
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    private func saveUser(_ user: User) async throws {
        let data = try Firestore.Encoder().encode(user)
        try await db.collection("users").document(user.id).setData(data)
    }
    
    func updateUser(_ user: User) async throws {
        guard let currentUser = auth.currentUser else { throw FirebaseError.notAuthenticated }
        var updatedUser = user
        updatedUser.updatedAt = Date()
        let data = try Firestore.Encoder().encode(updatedUser)
        try await db.collection("users").document(currentUser.uid).setData(data, merge: true)
        self.currentUser = updatedUser
    }
    
    // MARK: - Universities
    
    func fetchUniversities() async throws -> [University] {
        let snapshot = try await db.collection("universities").getDocuments()
        return try snapshot.documents.compactMap { document in
            try document.data(as: University.self)
        }
    }
    
    func fetchUniversity(id: String) async throws -> University? {
        let document = try await db.collection("universities").document(id).getDocument()
        return try document.data(as: University.self)
    }
    
    // MARK: - Study Programs
    
    func fetchPrograms(universityId: String? = nil) async throws -> [StudyProgram] {
        var query: Query = db.collection("programs")
        
        if let universityId = universityId {
            query = query.whereField("universityId", isEqualTo: universityId)
        }
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.compactMap { document in
            try document.data(as: StudyProgram.self)
        }
    }
    
    func fetchProgram(id: String) async throws -> StudyProgram? {
        let document = try await db.collection("programs").document(id).getDocument()
        return try document.data(as: StudyProgram.self)
    }
    
    func searchPrograms(query: String, filters: ProgramFilters? = nil) async throws -> [StudyProgram] {
        // This would be implemented with a more sophisticated search solution
        // For now, we'll fetch all and filter client-side
        let allPrograms = try await fetchPrograms()
        
        return allPrograms.filter { program in
            let matchesQuery = query.isEmpty || 
                program.name.localizedCaseInsensitiveContains(query) ||
                program.field.localizedCaseInsensitiveContains(query)
            
            let matchesFilters = filters?.matches(program) ?? true
            
            return matchesQuery && matchesFilters
        }
    }
    
    // MARK: - Saved Programs
    
    func saveProgram(programId: String) async throws {
        guard var user = currentUser else { throw FirebaseError.notAuthenticated }
        if !user.savedPrograms.contains(programId) {
            user.savedPrograms.append(programId)
            try await updateUser(user)
        }
    }
    
    func unsaveProgram(programId: String) async throws {
        guard var user = currentUser else { throw FirebaseError.notAuthenticated }
        user.savedPrograms.removeAll { $0 == programId }
        try await updateUser(user)
    }
    
    // MARK: - Erasmus Programs
    
    func fetchErasmusPrograms(universityId: String? = nil) async throws -> [ErasmusProgram] {
        var query: Query = db.collection("erasmusPrograms")
        
        if let universityId = universityId {
            query = query.whereField("universityId", isEqualTo: universityId)
        }
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.compactMap { document in
            try document.data(as: ErasmusProgram.self)
        }
    }
}

// MARK: - Supporting Types

enum FirebaseError: LocalizedError {
    case notAuthenticated
    case dataNotFound
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Musisz być zalogowany, aby wykonać tę operację"
        case .dataNotFound:
            return "Nie znaleziono danych"
        }
    }
}

struct ProgramFilters {
    var cities: [String]?
    var degrees: [Degree]?
    var modes: [StudyMode]?
    var fields: [String]?
    var maxTuition: Int?
    
    func matches(_ program: StudyProgram) -> Bool {
        // Implementation would check each filter
        return true
    }
}