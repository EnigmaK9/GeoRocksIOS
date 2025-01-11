// -----------------------------------------------------------
// VoiceOverChampion.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file illustrates how to add VoiceOver labels to make a SwiftUI
// interface more accessible. Use .accessibilityLabel to describe elements.
// -----------------------------------------------------------

import SwiftUI

/// A demonstration of how to make views accessible for VoiceOver.
struct AccessibilityExampleView: View {
    var body: some View {
        VStack(spacing: 20) {
            // A descriptive label is added for VoiceOver.
            Text("VoiceOver Champion")
                .font(.title)
                .accessibilityLabel("VoiceOver Champion Title")
            
            // The image includes an accessibility label for non-visual context.
            Image(systemName: "hand.point.up.left")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .accessibilityLabel("Hand Pointing Up Left Icon")
            
            // A button also uses an accessibility label.
            Button("Learn More") {
                // This could navigate or show more information.
            }
            .accessibilityLabel("Learn More Button")
            .padding()
        }
        .padding()
    }
}
