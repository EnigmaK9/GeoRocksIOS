// -----------------------------------------------------------
// AccountSettingsView.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file provides a professional SwiftUI view for account
// settings, including profile information, account settings,
// notifications, app preferences, and support options.
// It enhances the user interface with organized sections
// and intuitive navigation.
// -----------------------------------------------------------

import SwiftUI

struct AccountSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var notificationsEnabled = true
    @State private var emailNotifications = false
    @State private var smsNotifications = false
    @State private var darkModeEnabled = false
    
    var body: some View {
        NavigationView {
            Form {
                // Profile Section
                Section(header: Text("Profile")) {
                    HStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authViewModel.userEmail?.components(separatedBy: "@").first?.capitalized ?? "Administrador")
                                .font(.headline)
                            Text(authViewModel.userEmail ?? "admin@unam.mx")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
                
                // Account Section
                Section(header: Text("Account")) {
                    NavigationLink(destination: EmptyView()) {
                        Text("Change Password")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Privacy Settings")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Connected Accounts")
                    }
                }
                
                // Notifications Section
                Section(header: Text("Notifications")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    
                    if notificationsEnabled {
                        Toggle(isOn: $emailNotifications) {
                            Text("Email Notifications")
                        }
                        Toggle(isOn: $smsNotifications) {
                            Text("SMS Notifications")
                        }
                    }
                }
                
                // App Preferences Section
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $darkModeEnabled) {
                        Text("Dark Mode")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Language")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("About")
                    }
                }
                
                // Support Section
                Section(header: Text("Support")) {
                    NavigationLink(destination: EmptyView()) {
                        Text("Help Center")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Contact Us")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("Terms & Conditions")
                    }
                }
                
                // Logout Button
                Section {
                    Button(action: {
                        authViewModel.signOut()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Log Out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Account Settings")
        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
            .environmentObject(AuthViewModel())
    }
}
