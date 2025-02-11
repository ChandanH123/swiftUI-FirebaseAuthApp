//
//  AuthViewModel.swift
//  FirebaseAuthApp
//
//  Created by Chandan on 11/02/25.
//

import Foundation
import FirebaseAuth // Auth
import FirebaseFirestore // Storage

@MainActor // replacement of DispatchQueue.main.async, so we don't need to write it everywhere where we call async await.
final class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? // firebase user
    @Published var currentUser: User? // Local user
    @Published var isError: Bool = false
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    init() {
        Task {
            await loadCurrentUser()
        }
    }
    
    // use to check for userSession so it will present ProfileView directly if user is there otherwise will show LoginView.
    func loadCurrentUser() async {
        if let user = auth.currentUser {
            userSession = user
            await fetchUser(by: user.uid)
        }
    }
    
    // will be use for first time login to set the userSession then we will use it in ContentView.
    func login(email: String, password: String) async {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            userSession = authResult.user
            await fetchUser(by: authResult.user.uid)
        } catch {
            isError = true
        }
    }
    
    // will use to set the currentUser so we will use its data to show on ui.
    func fetchUser(by uid: String) async {
        do {
            let document = try await firestore.collection("users").document(uid).getDocument()
            currentUser = try document.data(as: User.self)
        } catch {
            isError = true
        }
    }

    // use to sigout the user session on firebase auth and make userSession & currentSession nil.
    func logOut() {
        do {
            userSession = nil
            currentUser = nil
            try auth.signOut()
        } catch {
           isError = true
        }
    }

    // use to create user on firebase auth.
    func createUser(email: String, fullName: String, password: String) async {
        do {
            // User entry in firebase auth.
            let authResult = try await auth.createUser(withEmail: email, password: password)
            // Storing user's extra details in firestore database.
            await storeUserInFirestore(uid: authResult.user.uid, email: email, fullName: fullName)
        } catch {
            isError = true
        }
    }
    
    // use to store the user's extra data into firestore database.
    func storeUserInFirestore(uid: String, email: String, fullName: String) async {
        let user = User(uid: uid, email: email, fullName: fullName)
        do {
            // make collection with name users then inside it make uid then inside it make user data.
            try firestore.collection("users").document(uid).setData(from: user)
        } catch {
            
        }
    }
    
}
