//
//  ShareRockFeature.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 11/01/25.
//

// ShareRockFeature.swift
// GeoRocksIOS

import SwiftUI

struct ShareRockFeature: View {
    let rockTitle: String
    let rockDetails: String
    
    @State private var isShareSheetPresented: Bool = false
    
    var body: some View {
        Button(action: {
            isShareSheetPresented = true
        }) {
            Text("Share Rock")
                .padding()
                .background(Color("ButtonDefault"))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ActivityViewController(activityItems: [rockTitle, rockDetails])
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
