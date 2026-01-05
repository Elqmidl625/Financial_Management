//
//  MoreView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 29/8/24.
//

import SwiftUI

struct MoreView: View {
    @StateObject private var session = UserSession.shared
    @State private var showSignUp = false
    @State private var showLogIn = false
    @State private var showDeleteSheet = false
    @State private var deletePassword: String = ""
    @State private var deleteError: String = ""
    var body: some View {
        NavigationStack {
        VStack(spacing: 0) {
            Text("More")
                .font(.title)
                .fontWeight(.bold)
            
            List {
                Section("Account") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                        Text("Current Account")
                        Spacer()
                        Text(session.currentUserId)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    
                    if !session.savedAccounts.isEmpty {
                        ForEach(session.savedAccounts, id: \.self) { email in
                            Button {
                                try? UserSession.shared.ensureUser(email: email)
                            } label: {
                                HStack {
                                    Image(systemName: "person.circle")
                                    Text(email)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        showSignUp = true
                    } label: {
                        HStack {
                            Image(systemName: "person.badge.plus")
                            Text("Sign Up")
                        }
                    }
                    Button {
                        showLogIn = true
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("Log In")
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        deletePassword = ""
                        deleteError = ""
                        showDeleteSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Current Account")
                        }
                    }
                    .disabled(session.currentUserId == "default")
                    Button(role: .destructive) {
                        session.currentUserId = "default"
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                    }
                }
                
                Section("Settings") {
                    NavigationLink {
                        CustomCategoryManagerView()
                    } label: {
                        HStack {
                            Image(systemName: "square.grid.2x2")
                            Text("Custom Categories")
                        }
                    }
                    
                    NavigationLink {
                        CurrencySelectionView()
                    } label: {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Currency")
                            Spacer()
                            Text(CurrencyManager.shared.currencySymbol)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .sheet(isPresented: $showLogIn) {
            LogInView()
        }
        .sheet(isPresented: $showDeleteSheet) {
            VStack(spacing: 16) {
                Text("Delete Account")
                    .font(.title2)
                    .fontWeight(.bold)
                Text(session.currentUserId)
                    .foregroundColor(.gray)
                SecureField("Enter password to confirm", text: $deletePassword)
                    .textContentType(.password)
                    .padding(.horizontal)
                if !deleteError.isEmpty {
                    Text(deleteError)
                        .foregroundColor(.red)
                }
                HStack {
                    Button("Cancel") {
                        showDeleteSheet = false
                    }
                    Spacer()
                    Button(role: .destructive) {
                        do {
                            try UserSession.shared.deleteAccount(email: session.currentUserId, password: deletePassword)
                            showDeleteSheet = false
                        } catch UserSession.AccountError.invalidPassword {
                            deleteError = "Incorrect password."
                        } catch {
                            deleteError = "Unable to delete account."
                        }
                    } label: {
                        Text("Delete")
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding()
        }
        }
        
    }
}

#Preview {
    MoreView()
}
