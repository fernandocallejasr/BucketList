//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Fernando Callejas on 15/09/24.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit
import _MapKit_SwiftUI

extension ContentView {
    
    class ViewModel: ObservableObject {
        @Published var selectedPlace: Location?
        @Published private(set) var locations: [Location]
        
        @Published var isUnlocked = false
        @Published var mapTypeSelection: MapSelection = .standard
        
        var mapStyle: MapStyle {
            switch mapTypeSelection {
            case .hybrid:
                return MapStyle.hybrid
            case .standard:
                return MapStyle.standard
            case .imagery:
                return MapStyle.imagery
            }
        }
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func saveLocations() {
            do {
                let data = try JSONEncoder().encode(locations)
                
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            saveLocations()
        }
        
        func updateLocation(_ location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                saveLocations()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        //error
                        print("Unable to unlock using biometrics")
                    }
                }
            } else {
                // no biometrics
                print("Device do not support biometrics authentication")
            }
                
        }
    }
    
}
