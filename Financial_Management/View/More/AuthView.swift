//
//  AuthView.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import SwiftUI

struct AuthView: View {
    
    @State private var showLogin: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Picker("", selection: $showLogin) {
                    Text("Sign Up").tag(false)
                    Text("Log In").tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if showLogin {
                    LogInView()
                } else {
                    SignUpView()
                }
                
                Spacer()
            }
            .navigationTitle("Welcome")
        }
    }
}

#Preview {
    AuthView()
}




