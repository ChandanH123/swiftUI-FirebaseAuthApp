//
//  LoginView.swift
//  FirebaseAuthApp
//
//  Created by Chandan on 11/02/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject private var authViewModel : AuthViewModel
    
    private var lineView: some View {
        VStack { Divider().frame(height: 1) }
    }
    
    private var logoView: some View {
        Image("login_image")
            .resizable()
            .scaledToFit()
    }
    
    private var titleView: some View {
        Text("Let's Connect With Us!")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    private var forgotButtonView: some View {
        HStack {
            Spacer()
            Button(action: {
                
            }, label: {
                Text("Forgot Password")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.medium)
            })
        }
    }
    
    private var loginButtonView: some View {
        Button(action: {
            Task {
                await authViewModel.login(email: email, password: password)
            }
        }, label: {
            Text("Login")
        })
        .buttonStyle(CapsuleButtonStyle())
    }
    
    private var inputView: some View {
        VStack {
            InputView(
                placeholder: "Email or phone number",
                text: $email
            )
            
            InputView(
                placeholder: "Password",
                isSecureField: true,
                text: $password
            )
        }
    }
    
    private var lineOrView: some View {
        HStack(spacing: 16) {
            lineView
            Text("or")
                .fontWeight(.semibold)
            lineView
        }
        .foregroundStyle(.gray)
    }
    
    private var appleButtonView: some View {
        Button(action: {
            
        }, label: {
            Label("Sign up with Apple", systemImage: "apple.logo")
        })
        .buttonStyle(
            CapsuleButtonStyle(
                bgColor: .black
            )
        )
    }
    
    private var googleButtonView: some View {
        Button(action: {
            
        }, label: {
            HStack {
                Image("google")
                    .resizable()
                    .frame(width: 15, height: 15)
                Text("Sign up with google")
            }
        })
        .buttonStyle(
            CapsuleButtonStyle(
                bgColor: .clear,
                textColor: .black,
                hasBorder: true
            )
        )
    }
    
    private var footerView: some View {
        NavigationLink {
            SignUpView()
                .environmentObject(authViewModel)
        } label: {
            HStack {
                Text("Don't have an account?")
                    .foregroundStyle(.black)
                Text("Sign up")
                    .foregroundStyle(.teal)
            }
            .fontWeight(.medium)
        }
    }
    
    private var topView: some View {
        VStack(spacing: 16) {
            logoView
            titleView
            Spacer().frame(height: 12)
            inputView
            forgotButtonView
            loginButtonView
        }
    }
    
    private var bottomView: some View {
        VStack(spacing: 16) {
            lineOrView
            appleButtonView
            googleButtonView
            footerView
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // top view
                    topView
                    
                    // bottom view
                    bottomView
                }
                .ignoresSafeArea()
                .padding(.horizontal) // by default is 16 left and right.
                .padding(.vertical, 8) // 8 top and bottom.
            }
        }
    }
}

#Preview {
    LoginView()
}
