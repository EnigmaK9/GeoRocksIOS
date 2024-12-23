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
            ZStack {
                // Background Color
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Welcome Text
                    Text("Welcome to Rocks!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DefaultTextColor"))
                        .padding()
                    
                    // Button to navigate to the rocks list
                    NavigationLink(destination: RocksListView()) {
                        Text("View All Rocks")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("ButtonDefault"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Sign Out Button
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Text("Logout")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .padding()
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Rocks List")
        }
    }
}

struct MainRocksView_Previews: PreviewProvider {
    static var previews: some View {
        MainRocksView()
            .environmentObject(AuthViewModel())
    }
}
