//
//  MapView.swift
//  GeoRocksIOS
//
//  Created by YourName on Today's Date.
//

import SwiftUI
import MapKit

struct MapView: View {
    let lat: Double
    let lon: Double
    
    @State private var region: MKCoordinateRegion
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region)
            .overlay(
                // Marker for the rock's location
                Circle()
                    .stroke(Color("ButtonDefault"), lineWidth: 2)
                    .frame(width: 30, height: 30)
            )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(lat: 37.7749, lon: -122.4194)
    }
}
