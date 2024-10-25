//
//  RunApp.swift
//  RunApp
//
//  Created by user265613 on 10/21/24.
//

import SwiftUI
import Firebase

@main
struct RunApp: App {
    @StateObject var authViewModel = AuthViewModel() // Create an instance of your AuthViewModel
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView() // The main screen that the app loads
                .environmentObject(authViewModel) // Pass AuthViewModel to the app
        }
    }
}

