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
    }
}
