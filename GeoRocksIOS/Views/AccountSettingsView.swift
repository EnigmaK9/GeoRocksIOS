// -----------------------------------------------------------
// AccountSettingsView.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file enables the user to update profile details such
// as name and email. The view also dismisses itself when
// the user taps the close button in the toolbar.
// -----------------------------------------------------------

import SwiftUI

// A string extension is provided to allow the alert(item:) usage.
extension String: Identifiable {
    public var id: String { self }
}

/// The AccountSettingsView is used for managing user account settings.
/// It relies on an AccountSettingsViewModel injected via @EnvironmentObject.
struct AccountSettingsView: View {
    @EnvironmentObject var accountSettingsViewModel: AccountSettingsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // Local states to hold user inputs for name and email.
    @State private var name: String = ""
    @State private var email: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    // TextField is used for editing the user's name.
                    TextField("Name", text: $name)
                    
                    // TextField is used for editing the user's email.
                    TextField("Email", text: $email)
                    
                    // A button is used to trigger a profile update action.
                    Button(action: {
                        accountSettingsViewModel.updateUserProfile(name: name, email: email)
                    }) {
                        Text("Update Profile")
                    }
                }
            }
            .navigationTitle("Account Settings")
            .toolbar {
                // The toolbar includes a close button on the trailing side.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            // An alert is shown if an error message is set in the ViewModel.
            .alert(item: $accountSettingsViewModel.updateProfileErrorMessage) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error),
                    dismissButton: .default(Text("OK"))
                )
            }
            // A separate alert is shown if a success message is set in the ViewModel.
            .alert(item: $accountSettingsViewModel.updateProfileSuccessMessage) { success in
                Alert(
                    title: Text("Success"),
                    message: Text(success),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
