//
 //  AuthViewModel.swift
 //  GeoRocksIOS
 //
 //  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
 //
 //  Description:
 //  The AuthViewModel manages user authentication state and related actions.
 //
 
 import SwiftUI
 import FirebaseAuth
 
 class AuthViewModel: ObservableObject {
     // A published property to track the user's login status
     @Published var isLoggedIn = false
     
     // Published properties for error and success messages
     @Published var errorMessage: String?
     @Published var successMessage: String?
     
     // Listener handle to manage the authentication state listener
     private var authListenerHandle: AuthStateDidChangeListenerHandle?
     
     init() {
         // Check if a user is already authenticated at the app's launch
         self.isLoggedIn = Auth.auth().currentUser != nil
         
         // Authentication state changes are being listened to
         authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
             DispatchQueue.main.async {
                 // The login status is updated based on the user's authentication state
                 self?.isLoggedIn = user != nil
             }
         }
     }
     
     deinit {
         // Remove the authentication state listener when the ViewModel is deinitialized
         if let handle = authListenerHandle {
             Auth.auth().removeStateDidChangeListener(handle)
         }
     }
     
     // MARK: - Sign In with Email/Password
     func signIn(email: String, password: String) {
         // A sign-in attempt is made using the provided email and password
         Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
             DispatchQueue.main.async {
                 if let error = error {
                     // Set the error message to be displayed
                     self?.errorMessage = error.localizedDescription
                     print("Error signing in: \(error.localizedDescription)")
                 } else {
                     // If the sign-in is successful, the login status is marked as true
                     self?.isLoggedIn = true
                 }
             }
         }
     }
     
     // MARK: - Register (Create Account)
     func register(email: String, password: String) {
         // An account creation attempt is made using the provided email and password
         Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
             DispatchQueue.main.async {
                 if let error = error {
                     // Set the error message to be displayed
                     self?.errorMessage = error.localizedDescription
                     print("Error registering: \(error.localizedDescription)")
                 } else {
                     // If the registration is successful, the login status is marked as true
                     self?.isLoggedIn = true
                     // Optionally, set a success message
                     self?.successMessage = "Account created successfully!"
                 }
             }
         }
     }
     
     // MARK: - Reset Password
     func resetPassword(email: String) {
         // A password reset email is sent to the provided email address
         Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
             DispatchQueue.main.async {
                 if let error = error {
                     // Set the error message to be displayed
                     self?.errorMessage = error.localizedDescription
                     print("Error sending password reset: \(error.localizedDescription)")
                 } else {
                     // Set a success message to inform the user
                     self?.successMessage = "Password reset email sent to \(email)."
                     print("Password reset email sent to \(email)")
                 }
             }
         }
     }
     
     // MARK: - Sign Out
     func signOut() {
         do {
             // An attempt is made to sign out the current user
             try Auth.auth().signOut()
             // If the sign-out is successful, the login status is marked as false
             self.isLoggedIn = false
         } catch {
             // Set the error message to be displayed
             self.errorMessage = error.localizedDescription
             print("Error signing out: \(error.localizedDescription)")
         }
     }
     
     // MARK: - Clear Messages
     func clearMessages() {
         errorMessage = nil
         successMessage = nil
     }
     
     /// Checks the authentication status and updates the loading state accordingly.
     /// - Parameter completion: A closure that returns a boolean indicating authentication success.
     func checkAuthenticationStatus(completion: @escaping (Bool) -> Void) {
         // The current user is retrieved from FirebaseAuth.
         if Auth.auth().currentUser != nil {
             // The user is authenticated.
             completion(true)
         } else {
             // The user is not authenticated.
             completion(false)
         }
     }
 }
