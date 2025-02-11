//
//  ProfileView.swift
//  FirebaseAuthApp
//
//  Created by Chandan on 11/02/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel : AuthViewModel
    
    var body: some View {
        VStack {
            Spacer()
            if let currentUser = authViewModel.currentUser {
                Text(currentUser.fullName)
            } else {
                ProgressView("Please wait...")
            }
            Spacer()
            
            Button("Log out") {
                authViewModel.logOut()
            }
        }
    }
}

#Preview {
    ProfileView()
}
