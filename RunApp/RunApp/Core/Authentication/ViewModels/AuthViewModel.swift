//
//  AuthViewModel.swift
//  RunningApp
//
//  Created by user265613 on 10/21/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    // Function to sign in
    func signIn(withUsername username: String, password: String) async throws {
        do {
            let placeholderEmail = "\(username)@example.com"
            let result = try await Auth.auth().signIn(withEmail: placeholderEmail, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }

    // Function to register a new user
    func createUser(withUsername username: String, password: String) async throws {
        do {
            let placeholderEmail = "\(username)@example.com"
            let result = try await Auth.auth().createUser(withEmail: placeholderEmail, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, username: username)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()

        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }

    // Function to check if the username is available
    func checkUsernameAvailability(username: String) async throws -> Bool {
        let querySnapshot = try await Firestore.firestore().collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        return querySnapshot.documents.isEmpty
    }
    
    // Fetch the current user data
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
}
