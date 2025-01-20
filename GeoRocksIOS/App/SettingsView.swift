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
                // MARK: - User Profile Section
                Section {
                    HStack(spacing: 15) {
                        // User profile image
                        Image("userAvatarPlaceholder") // Replace with actual image or user avatar
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.gray, lineWidth: 1)
                            )

                        // User name and email
                        VStack(alignment: .leading, spacing: 5) {
                            Text("John Doe") // Replace with actual user name
                                .font(.headline)
                            Text("john.doe@example.com") // Replace with actual user email
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 10)
                }

                // MARK: - Appearance Settings Section
                Section(header: Text("Appearance")) {
                    // Dark Mode Toggle with icon
                    Toggle(isOn: $settingsViewModel.isDarkMode) {
                        HStack {
                            Image(systemName: settingsViewModel.isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                                .foregroundColor(settingsViewModel.isDarkMode ? .yellow : .orange)
                            Text("Dark Mode")
                        }
                    }
                    .accessibilityLabel("Toggle Dark Mode")

                    // Font Size Slider with icon
                    HStack {
                        Image(systemName: "textformat.size")
                            .foregroundColor(.blue)
                        Text("Font Size")
                        Slider(value: $settingsViewModel.fontSize, in: 12...24, step: 1)
                        Text("\(Int(settingsViewModel.fontSize)) pt")
                            .foregroundColor(.secondary)
                    }
                    .accessibilityLabel("Adjust Font Size")

                    // High Contrast Toggle with icon
                    Toggle(isOn: $settingsViewModel.highContrast) {
                        HStack {
                            Image(systemName: "circle.lefthalf.filled")
                                .foregroundColor(.black)
                            Text("High Contrast")
                        }
                    }
                    .accessibilityLabel("Toggle High Contrast")
                }

                // MARK: - Notifications Section
                Section(header: Text("Notifications")) {
                    Toggle(isOn: .constant(true)) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Push Notifications")
                        }
                    }
                    .disabled(true) // Example toggle that's currently disabled
                }

                // MARK: - About Section
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text("About")
                        }
                    }

                    NavigationLink(destination: PrivacyPolicyView()) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.red)
                            Text("Privacy Policy")
                        }
                    }
                }
            }
            // The navigation title is set to "Settings".
            .navigationTitle("Settings")
            // The toolbar is configured to add a close button.
            .toolbar {
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
                    .accessibilityLabel("Close Settings")
                }
            }
        }
    }
}

// MARK: - Placeholder Views for Navigation Links
struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("GeoRocksIOS")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Version 1.0.0")
                .font(.title3)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            Text("""
            **Privacy Policy**

            Your privacy is important to us. This policy explains how we handle and use your personal information and your rights in relation to that information.

            *We do not collect any personal data.* For more information, please contact us.
            """)
                .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel()) // Provides SettingsViewModel for preview.
    }
}
