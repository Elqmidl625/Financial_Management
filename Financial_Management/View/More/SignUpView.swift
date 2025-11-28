//
//  SignUpView.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import SwiftUI
import CoreData

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var showSavePrompt: Bool = false
    @State private var createdEmail: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Account") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    TextField("User name", text: $userName)
                    SecureField("Password", text: $password)
                    SecureField("Confirm password", text: $confirmPassword)
                }
                
                Section {
                    Button("Sign Up") {
                        signUp()
                    }
                }
            }
            .navigationTitle("Sign Up")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign Up"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("OK")))
            }
            .confirmationDialog("Save this account for quick switching?",
                                isPresented: $showSavePrompt,
                                titleVisibility: .visible) {
                Button("Save") {
                    UserSession.shared.saveAccount(email: createdEmail)
                    UserSession.shared.setCurrentUser(email: createdEmail)
                    dismiss()
                }
                Button("Not now", role: .cancel) {
                    UserSession.shared.setCurrentUser(email: createdEmail)
                    dismiss()
                }
            }
        }
    }
}

private extension SignUpView {
    func signUp() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmedEmail.isEmpty, !userName.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showAlert = true
            return
        }
        do {
            if try UserSession.shared.userExists(email: trimmedEmail) {
                errorMessage = "Email already exists. Please log in."
                showAlert = true
                return
            }
            _ = try UserSession.shared.createUser(email: trimmedEmail,
                                                  userName: userName,
                                                  password: password)
            createdEmail = trimmedEmail
            showSavePrompt = true
        } catch {
            errorMessage = "Failed to create account."
            showAlert = true
        }
    }
}

#Preview {
    SignUpView()
}


