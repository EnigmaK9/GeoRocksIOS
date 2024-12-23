//
//  ForgotPasswordView.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 23/12/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    
    // State variables for controlling alerts
    @State private var showErrorAlert: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // State variable to manage loading state
    @State private var isLoading: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // AppIcon Image
                Image("logo") // Ensure "logo" matches the image name in Assets.xcassets/AppIcon.appiconset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 50)
                
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("DefaultTextColor"))
                
                VStack(spacing: 15) {
                    // Email Input
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .padding(.horizontal, 20)
                        .background(Color("DefaultBackground"))
                        .cornerRadius(8)
                }
                
                // Reset Password Button
                Button(action: {
                    resetPassword()
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Send Reset Link")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("ButtonDefault"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .disabled(isLoading)
                .buttonStyle(CustomButtonStyle())
                
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Reset Password", displayMode: .inline)
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
    
    // MARK: - Reset Password Function
    private func resetPassword() {
        // Input Validation
        guard !email.isEmpty else {
            alertMessage = "Please enter your email."
            showErrorAlert = true
            return
        }
        
        // Optionally, add more validation (e.g., email format)
        
        // Set loading state
        isLoading = true
        
        // Call AuthViewModel's resetPassword function
        authViewModel.resetPassword(email: email)
        
        // Reset loading state after a delay to allow AuthViewModel to process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
        }
    }
    
    // MARK: - Custom Button Style
    struct CustomButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    configuration.isPressed ?
                    Color("ButtonPressed") :
                    Color("ButtonDefault")
                )
                .cornerRadius(8)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(AuthViewModel())
    }
}
