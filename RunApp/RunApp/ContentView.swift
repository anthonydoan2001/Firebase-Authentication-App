//
//  ContentView.swift
//  RunApp
//
//  Created by user265613 on 10/21/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Group {
            if viewModel.userSession != nil {
                // Show the tab bar only after authentication
                AuthenticatedTabView()
            } else {
                // Show login view if not authenticated
                LoginView()
            }
        }
    }
}

// Define the tab bar that will include ProfileView and RunWithOmegas views
struct AuthenticatedTabView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}


