// SettingsView.swift
// GeoRocksIOS

import SwiftUI

struct SettingsView: View {
    // The SettingsViewModel is accessed from the environment.
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    // Environment variable to manage presentation mode.
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // A navigation view is provided to enable navigation within the settings.
        NavigationView {
            // A form is used to organize settings options.
            Form {
                // A section is created for theme-related settings.
                Section(header: Text("Appearance")) {
                    // A toggle switch is provided for Dark Mode.
                    Toggle(isOn: $settingsViewModel.isDarkMode) {
                        // A label is provided for the toggle switch.
                        Text("Dark Mode")
                    }
                    // Accessibility label is added to improve accessibility support.
                    .accessibilityLabel("Toggle Dark Mode")
                    
                    // Example: Slider for font size.
                    HStack {
                        Text("Font Size")
                        Slider(value: $settingsViewModel.fontSize, in: 12...24, step: 1)
                        Text("\(Int(settingsViewModel.fontSize))")
                    }
                    .accessibilityLabel("Adjust Font Size")
                    
                    // High Contrast Toggle
                    Toggle(isOn: $settingsViewModel.highContrast) {
                        Text("High Contrast")
                    }
                    .accessibilityLabel("Toggle High Contrast")
                }
                
                // Additional settings sections can be added here.
            }
            // The navigation title is set to "Settings".
            .navigationTitle("Settings")
            // The toolbar is configured to add a close button.
            .toolbar {
                // A toolbar item is added to the navigation bar's leading side.
                ToolbarItem(placement: .navigationBarTrailing) {
                    // A button is provided to dismiss the SettingsView.
                    Button(action: {
                        // The SettingsView is dismissed when the button is tapped.
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        // An "X" mark icon is used to represent the close action.
                        Image(systemName: "xmark")
                            .foregroundColor(Color("ButtonDefault"))
                    }
                    // Accessibility label is added for the close button.
                    .accessibilityLabel("Close Settings")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel()) // Provides SettingsViewModel for preview.
    }
}
