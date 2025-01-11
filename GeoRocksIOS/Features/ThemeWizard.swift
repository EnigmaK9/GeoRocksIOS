// -----------------------------------------------------------
// ThemeWizard.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file manages a simple theme toggling system between light and dark modes.
// The shared ThemeManager class is used, and dynamic colors are provided.
// -----------------------------------------------------------

import SwiftUI

/// ThemeManager maintains a published property representing the current theme.
class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .light
    static let shared = ThemeManager()
    
    private init() {}
    
    /// This function switches the theme from light to dark or vice versa.
    func toggleTheme() {
        currentTheme = (currentTheme == .light) ? .dark : .light
    }
}

/// AppTheme is a simple enumeration for representing the user's current theme.
enum AppTheme {
    case light
    case dark
}

/// Extension on Color to provide dynamic background and foreground colors.
extension Color {
    static var dynamicBackground: Color {
        ThemeManager.shared.currentTheme == .light ? .white : .black
    }
    
    static var dynamicForeground: Color {
        ThemeManager.shared.currentTheme == .light ? .black : .white
    }
}

/// A SwiftUI view demonstrating the theme toggle process.
struct ThemeExampleView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            Color.dynamicBackground.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Theme Wizard")
                    .font(.title)
                    .foregroundColor(Color.dynamicForeground)
                
                Button("Toggle Theme") {
                    themeManager.toggleTheme()
                }
                .padding()
                .background(Color.dynamicForeground)
                .foregroundColor(Color.dynamicBackground)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}
