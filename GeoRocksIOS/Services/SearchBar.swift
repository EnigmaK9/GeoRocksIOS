//
//  SearchBar.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 11/01/25.
//

// SearchBar.swift
// GeoRocksIOS

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 8)
    }
}
