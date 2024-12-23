//
//  MainRocksView.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
//

import SwiftUI

struct MainRocksView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // TODO: Replace with your RocksList
                Text("Welcome to Rocks!")
                    .font(.title)
                    .padding()
                
                // Sign Out Button
                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Rocks List")
        }
    }
}
