//
//  IntegratingMapKit.swift
//  BucketList
//
//  Created by Fernando Callejas on 09/09/24.
//

import MapKit
import SwiftUI

struct IntegratingMapKit: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    @State private var theVesselLocation = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.754, longitude: -74.00237),
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        )
    )
    
    let locations = [
        LocalLocation(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        LocalLocation(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    
    var body: some View {
        VStack {
//            Map(position: $position, interactionModes: [.rotate, .pitch, .pan, .zoom])
//                .mapStyle(.standard)
//                .onMapCameraChange { context in
//                    print(context.region)
//                }
            
//            Map {
//                ForEach(locations) { location in
////                    Marker(location.name, coordinate: location.coordinate)
//                    
//                    Annotation(location.name, coordinate: location.coordinate) {
//                        Text(location.name)
//                            .font(.headline)
//                            .padding()
//                            .background(.blue)
//                            .foregroundStyle(.white)
//                            .clipShape(.capsule)
//                    }
//                    .annotationTitles(.hidden)
//                }
//            }
            
            MapReader { proxy in
                Map(position: $position)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            print(coordinate)
                        }
                    }
            }
            
            HStack(spacing: 50) {
                Button("Paris") {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                }
                .buttonModifier()
                
                Button("Tokyo") {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                }
                .buttonModifier()
            }
        }
    }
}

struct LocalLocation: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

extension View {
    func buttonModifier() -> some View {
        modifier(ButtonViewModifier())
    }
}

struct ButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 100, height: 50)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 25, style: .circular))
            .tint(.primary)
    }
    
}


#Preview {
    IntegratingMapKit()
        .preferredColorScheme(.dark)
}
