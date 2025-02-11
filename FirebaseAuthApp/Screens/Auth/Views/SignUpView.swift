//
//  CreateAccountView.swift
//  FirebaseAuthApp
//
//  Created by Chandan on 11/02/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject private var authViewModel : AuthViewModel
    @Environment (\.presentationMode) var presentationMode // use to pop the view.

    private var isValidPassword: Bool {
        confirmPassword == password
    }

    private var headlineView: some View {
        VStack {
            Text("Please fill all information to create an account.")
                .padding(.vertical)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
    }

    private var inputView: some View {
        VStack {
            InputView(
                placeholder: "Email or phone number",
                text: $email
            )
            
            InputView(
                placeholder: "Full name",
                text: $fullName
            )
            
            InputView(
                placeholder: "Password",
                isSecureField: true,
                text: $password
            )
            
            ZStack(alignment: .trailing) {
                InputView(
                    placeholder: "Confirm your password",
                    isSecureField: true,
                    text: $confirmPassword
                )
                if !password.isEmpty && !confirmPassword.isEmpty {
                    Image(systemName: "\(isValidPassword ? "checkmark" : "xmark").circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundStyle(isValidPassword ? .green : .red)
                    
                }
            }
        }
    }
    
    private var createAccountButtonView: some View {
        Button(action: {
            Task {
                await authViewModel.createUser(
                    email: email,
                    fullName: fullName,
                    password: password
                )
                
                // if error is false only then dismiss back to login view otherwise stay on sign up view.
                if !authViewModel.isError {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        },
               label: {
            Text("Create Account")
        })
        .buttonStyle(CapsuleButtonStyle())
    }
    
    var body: some View {
        VStack(spacing: 16) {
            headlineView
            inputView
            Spacer()
            createAccountButtonView
        }
        .padding(.horizontal)
        .navigationTitle("Set up your account") // will set the navigation title.
        .toolbarRole(.editor) // will remove back button title.
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
