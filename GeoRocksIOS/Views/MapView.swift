//
//  MapView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//
//  Description:
//  An interactive SwiftUI view that displays a map centered on specified coordinates.
//  Custom annotations are rendered using the latest MapKit APIs compatible with iOS 17.
//
//  Updates:
//  - Deprecated initializers and annotations have been replaced with MapContentBuilder and Annotation.
//  - Enhanced comments have been added for easier debugging and maintenance.
//  - Compatibility has been ensured with iOS 17 or later.
//

import SwiftUI
import MapKit

/// Model representing a custom annotation for the map
struct RockAnnotation: Identifiable {
    let id = UUID() // A unique identifier for the annotation
    let coordinate: CLLocationCoordinate2D // The coordinates of the annotation
}

struct MapView: View {
    let lat: Double // The latitude to center the map
    let lon: Double // The longitude to center the map

    @State private var cameraPosition: MapCameraPosition // The camera position state

    // An array of annotations to be displayed on the map
    let annotations: [RockAnnotation]

    /// Initializes the view with specified latitude and longitude.
    /// The cameraPosition state is configured during initialization.
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon

        // An initial region is defined with the provided latitude and longitude
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )

        // The cameraPosition is initialized using the defined region
        _cameraPosition = State(initialValue: MapCameraPosition.region(region))

        // The annotations array is initialized with a RockAnnotation instance
        annotations = [
            RockAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        ]
    }

    var body: some View {
        // The Map view is configured with the updated initializer
        Map(
            position: $cameraPosition,
            interactionModes: .all // All interaction modes are allowed
        ) {
            // The user's current location is displayed on the map
            UserAnnotation()

            // Custom annotations are iterated over and added to the map
            ForEach(annotations) { annotation in
                Annotation("rock", coordinate: annotation.coordinate, anchor: .center) {
                    VStack {
                        Circle()
                            .stroke(Color.blue, lineWidth: 2) // A blue circle is drawn around the annotation
                            .frame(width: 30, height: 30)
                        Text("🪨") // An optional emoji is displayed below the circle
                            .font(.caption)
                    }
                }
            }
        }
        .ignoresSafeArea() // The map is allowed to extend beyond safe area boundaries
        // A debugging tip is provided below to verify annotation coordinates if they do not appear
        // Debugging Tip: If annotations do not appear, verify the `coordinate` values.
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        // A preview is provided with a specific location (San Francisco, CA)
        MapView(lat: 37.7749, lon: -122.4194)
    }
}
