//
//  ContentView.swift
//  BucketList
//
//  Created by Fernando Callejas on 31/08/24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )

    var body: some View {
        NavigationStack {
            Map(initialPosition: startPosition)
                .onTapGesture { position in
                    print("Tapped at: \(position)")
                }
        }
    }
}

#Preview {
    ContentView()
}
