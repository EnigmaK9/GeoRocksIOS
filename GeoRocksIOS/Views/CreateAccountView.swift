//
//  CreateAccountView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // State variables for controlling alerts
    @State private var showErrorAlert: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // State variable to manage loading state
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Email Input
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
            
            // Password Input
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Confirm Password Input
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Register Button
            Button(action: {
                register()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Register")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(isLoading)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .navigationBarTitle("Create Account", displayMode: .inline)
        // Observe changes in AuthViewModel's errorMessage and successMessage
        .onReceive(authViewModel.$errorMessage) { error in
            if let error = error {
                alertMessage = error
                showErrorAlert = true
            }
        }
        .onReceive(authViewModel.$successMessage) { success in
            if let success = success {
                alertMessage = success
                showSuccessAlert = true
            }
        }
        // Present error alert
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    authViewModel.clearMessages()
                }
            )
        }
        // Present success alert
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    authViewModel.clearMessages()
                }
            )
        }
    }
    
    // MARK: - Register Function
    private func register() {
        // Input Validation
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "All fields are required."
            showErrorAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showErrorAlert = true
            return
        }
        
        // Optionally, add more validation (e.g., password strength)
        
        // Set loading state
        isLoading = true
        
        // Call AuthViewModel's register function
        authViewModel.register(email: email, password: password)
        
        // Reset loading state after a delay to allow AuthViewModel to process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(AuthViewModel())
    }
}
