//
//  ContentView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import SwiftUI

/**
 ContentView is a simple SwiftUI structure, often generated by default.
 You may use it as:
 - A placeholder or welcome screen
 - A splash screen
 - A simple test view for your layout
 */
struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to GeoRocks iOS!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This is your starting view. You can replace it with LoginView or MainRocksView, depending on your app flow.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                NavigationLink(destination: LoginView()) {
                    Text("Go to Login")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.cornerRadius(8))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 32)
                
                NavigationLink(destination: MainRocksView()) {
                    Text("Go to Rocks List")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.green.cornerRadius(8))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Content View")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
