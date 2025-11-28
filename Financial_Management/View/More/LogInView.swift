//
//  LogInView.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import SwiftUI
import CoreData

struct LogInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Account") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                }
                
                Section {
                    Button("Log In") {
                        logIn()
                    }
                }
            }
            .navigationTitle("Log In")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Log In"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

private extension LogInView {
    func logIn() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        do {
            let ok = try UserSession.shared.login(email: trimmedEmail, password: password)
            if ok {
                dismiss()
            } else {
                errorMessage = "Invalid email or password."
                showAlert = true
            }
        } catch {
            errorMessage = "Failed to log in."
            showAlert = true
        }
    }
}

#Preview {
    LogInView()
}




