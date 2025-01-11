//
//  AccountSettingsView.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 11/01/25.
//
//  This extension is provided to allow String to conform to Identifiable.
//  It is used so that the alert(item:content:) method can be invoked without errors.

extension String: Identifiable {
    public var id: String { self }
}

//  The AccountSettingsView is used for managing user account settings
//  and updating profile information. SwiftUI's EnvironmentObject property
//  wrapper is utilized to access the AccountSettingsViewModel.

import SwiftUI

struct AccountSettingsView: View {
    // The AccountSettingsViewModel is injected from a higher-level view or the App struct.
    @EnvironmentObject var accountSettingsViewModel: AccountSettingsViewModel
    
    // The presentationMode environment property is used to dismiss the current view.
    @Environment(\.presentationMode) var presentationMode
    
    // A state variable is declared for storing the user's name input.
    @State private var name: String = ""
    
    // A state variable is declared for storing the user's email input.
    @State private var email: String = ""
    
    var body: some View {
        // A NavigationView is used to display the form with a navigation bar.
        NavigationView {
            // A Form is used to organize the user inputs and update actions.
            Form {
                // A Section is created for profile-related fields and actions.
                Section(header: Text("Profile")) {
                    // The TextField is used for capturing the user's name.
                    TextField("Name", text: $name)
                    
                    // The TextField is used for capturing the user's email.
                    TextField("Email", text: $email)
                    
                    // A Button is provided to trigger the profile update action.
                    Button(action: {
                        // The updateUserProfile function is called with the name and email.
                        accountSettingsViewModel.updateUserProfile(name: name, email: email)
                    }) {
                        // The Button is labeled with "Update Profile".
                        Text("Update Profile")
                    }
                }
            }
            // The navigationTitle is set to identify the current view as "Account Settings".
            .navigationTitle("Account Settings")
            
            // The toolbar is configured to include a dismiss button on the navigation bar.
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // A Button is used to dismiss the current view.
                    Button(action: {
                        // The wrappedValue of presentationMode is set to dismiss.
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        // The Button is labeled with an "xmark" system image icon.
                        Image(systemName: "xmark")
                    }
                }
            }
            
            // An alert is displayed if the updateProfileErrorMessage is non-nil.
            .alert(item: $accountSettingsViewModel.updateProfileErrorMessage) { error in
                // The Alert is constructed with the error message.
                Alert(title: Text("Error"), message: Text(error), dismissButton: .default(Text("OK")))
            }
            
            // A separate alert is displayed if the updateProfileSuccessMessage is non-nil.
            .alert(item: $accountSettingsViewModel.updateProfileSuccessMessage) { success in
                // The Alert is constructed with the success message.
                Alert(title: Text("Success"), message: Text(success), dismissButton: .default(Text("OK")))
            }
        }
    }
}
