//
//  LoginView.swift
//  GeoRocksIOS
//
//  Created by YourName on Today's Date.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("GeoRocks iOS")
                .font(.largeTitle)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                authViewModel.signIn(email: email, password: password)
            }) {
                Text("Sign In")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.cornerRadius(8))
                    .foregroundColor(.white)
            }
            
            Button(action: {
                authViewModel.register(email: email, password: password)
            }) {
                Text("Create Account")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            Button(action: {
                authViewModel.resetPassword(email: email)
            }) {
                Text("Forgot your password?")
                    .foregroundColor(.blue)
                    .underline()
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
}
