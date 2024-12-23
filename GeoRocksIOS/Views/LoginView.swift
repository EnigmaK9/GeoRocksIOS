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
    
    var body: some View {
        VStack(spacing: 20) {
            // The title "GeoRocks iOS" is displayed with a large font
            Text("GeoRocks iOS")
                .font(.largeTitle)
            
            // An email input field is provided for the user
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // A rounded border style is applied
                .autocapitalization(.none) // Automatic capitalization is disabled
                .disableAutocorrection(true) // Automatic correction is disabled
            
            // A password input field is provided for the user
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // A rounded border style is applied
            
            // A button labeled "Sign In" is provided to initiate the sign-in process
            Button(action: {
                // The signIn function is called with the provided email and password
                authViewModel.signIn(email: email, password: password)
            }) {
                Text("Sign In")
                    .fontWeight(.semibold) // The text is given a semi-bold font weight
                    .frame(maxWidth: .infinity) // The button expands to the maximum available width
                    .padding() // Padding is added around the text
                    .background(Color.blue.cornerRadius(8)) // A blue background with rounded corners is applied
                    .foregroundColor(.white) // The text color is set to white
            }
            
            // A button labeled "Create Account" is provided to initiate the registration process
            Button(action: {
                // The register function is called with the provided email and password
                authViewModel.register(email: email, password: password)
            }) {
                Text("Create Account")
                    .fontWeight(.semibold) // The text is given a semi-bold font weight
                    .foregroundColor(.blue) // The text color is set to blue
            }
            
            // A button labeled "Forgot your password?" is provided to initiate the password reset process
            Button(action: {
                // The resetPassword function is called with the provided email
                authViewModel.resetPassword(email: email)
            }) {
                Text("Forgot your password?")
                    .foregroundColor(.blue) // The text color is set to blue
                    .underline() // The text is underlined
            }
            
            Spacer() // A spacer is added to push the content upwards
        }
        .padding(.horizontal, 32) // Horizontal padding is applied to the entire VStack
        .navigationBarHidden(true) // The navigation bar is hidden for this view
        .navigationBarTitle("") // The navigation bar title is set to an empty string
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        // A preview of the LoginView is provided with an instance of AuthViewModel
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
