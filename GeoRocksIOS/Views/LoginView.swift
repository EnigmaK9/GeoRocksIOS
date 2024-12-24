//
//  LoginView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import SwiftUI

struct LoginView: View {
    // The AuthViewModel is accessed from the environment
    @EnvironmentObject var authViewModel: AuthViewModel

    // State variables are used to store the user's email and password input
    @State private var email: String = ""
    @State private var password: String = ""
    
    // State variables for controlling alerts
    @State private var showErrorAlert: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // State variable to manage loading state
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // AppIcon Image (Added logo above the title)
                    Image("Logo") // "Logo" is the name of your logo in Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100) // Adjust size as needed
                        .padding(.top, 50)
                    
                    // The title "GeoRocks UNAM" is displayed with a large font
                    Text("GeoRocks UNAM")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DefaultTextColor")) // Custom color
                    
                    VStack(spacing: 15) {
                        // An email input field is provided for the user
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // A rounded border style is applied
                            .autocapitalization(.none) // Automatic capitalization is disabled
                            .disableAutocorrection(true) // Automatic correction is disabled
                            .keyboardType(.emailAddress)
                            .padding(.horizontal, 20)
                            .background(Color("DefaultBackground"))
                            .cornerRadius(8)
                        
                        // A password input field is provided for the user
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // A rounded border style is applied
                            .padding(.horizontal, 20)
                            .background(Color("DefaultBackground"))
                            .cornerRadius(8)
                    }
                    
                    // A button labeled "Sign In" is provided to initiate the sign-in process
                    Button(action: {
                        signIn()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Sign In")
                                .fontWeight(.semibold) // The text is given a semi-bold font weight
                                .frame(maxWidth: .infinity) // The button expands to the maximum available width
                                .padding()
                                .background(Color("ButtonDefault")) // Custom button color
                                .foregroundColor(.white) // The text color is set to white
                                .cornerRadius(8) // Rounded corners
                        }
                    }
                    .disabled(isLoading)
                    .buttonStyle(CustomButtonStyle()) // Apply custom button style
                    
                    // NavigationLink to CreateAccountView
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Create Account")
                            .fontWeight(.semibold) // The text is given a semi-bold font weight
                            .foregroundColor(Color("ButtonDefault")) // Custom color matching button
                    }
                    
                    // NavigationLink to ForgotPasswordView
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot your password?")
                            .foregroundColor(Color("ButtonDefault")) // The text color is set to custom color
                            .underline() // The text is underlined
                    }
                    
                    Spacer() // A spacer is added to push the content upwards
                }
                .padding(.horizontal, 32) // Horizontal padding is applied to the entire VStack
            }
            .navigationBarHidden(true) // The navigation bar is hidden for this view
            .navigationBarTitle("") // The navigation bar title is set to an empty string
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
    }
    
    // MARK: - Sign In Function
    private func signIn() {
        // Input Validation
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please enter both email and password."
            showErrorAlert = true
            return
        }
        
        // Optionally, add more validation (e.g., email format)
        
        // Set loading state
        isLoading = true
        
        // Call AuthViewModel's signIn function
        authViewModel.signIn(email: email, password: password)
        
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

    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            // A preview of the LoginView is provided with an instance of AuthViewModel
            LoginView()
                .environmentObject(AuthViewModel())
        }
    }
}
