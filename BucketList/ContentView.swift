//
//  ContentView.swift
//  BucketList
//
//  Created by Fernando Callejas on 31/08/24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var locations = [Location]()
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.495919861354125, longitude: -0.13950367958915583),
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    )

    var body: some View {
        NavigationStack {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(locations) { location in
                        Marker(location.name, systemImage: "star", coordinate: CLLocationCoordinate2D(
                            latitude: location.latitude, longitude: location.longitude)
                        )
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print("Tapped at \(coordinate)")
                        
                        let newLocation = Location(id: UUID(), name: "New Location", description: "Description", latitude: coordinate.latitude, longitude: coordinate.longitude)
                        locations.append(newLocation)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
