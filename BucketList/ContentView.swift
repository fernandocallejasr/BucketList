//
//  ContentView.swift
//  BucketList
//
//  Created by Fernando Callejas on 31/08/24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
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
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name,coordinate: location.coordinate) {
                            CustomMapMarkerAnnotation()
                                .onLongPressGesture {
                                    viewModel.selectedPlace = location
                                }
                        }
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print("Tapped at \(coordinate)")
                        
                        viewModel.addLocation(at: coordinate)
                    }
                }
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            EditMapMarkerView(location: place) { newLocation in
                viewModel.updateLocation(newLocation)
            }
        }
    }
}

#Preview {
    ContentView()
}
