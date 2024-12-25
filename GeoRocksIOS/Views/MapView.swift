//
//  MapView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import SwiftUI
import MapKit

// Custom Annotation Model
struct RockAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    let lat: Double
    let lon: Double
    
    @State private var region: MKCoordinateRegion
    
    // Initialize the map region based on provided latitude and longitude
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        ))
    }
    
    var body: some View {
        // Define the annotation(s)
        let annotations = [RockAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))]
        
        // Use the updated Map initializer with annotationItems and annotationContent
        Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
            // Use MapAnnotation for custom marker
            MapAnnotation(coordinate: annotation.coordinate) {
                Circle()
                    .stroke(Color("ButtonDefault"), lineWidth: 2)
                    .frame(width: 30, height: 30)
            }
        }
        .ignoresSafeArea() // Optional: To make the map cover the entire view
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(lat: 37.7749, lon: -122.4194)
    }
}
