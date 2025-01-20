//
//  MainRocksView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2023.
//

import SwiftUI

struct MainRocksView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            RocksListView()
                .navigationBarTitle("GeoRocks")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            Text("Logout")
                        }
                    }
                }
        }
    }
}

struct MainRocksView_Previews: PreviewProvider {
    static var previews: some View {
        MainRocksView()
            .environmentObject(AuthViewModel())
    }
}
